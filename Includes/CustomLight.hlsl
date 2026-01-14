#ifndef CUSTOM_LIGHT_INCLUDED
#define CUSTOM_LIGHT_INCLUDED

#include "Functions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#define MAX_POINTLIGHT 4
#define SPECULAR_GLOSSNESS 5

struct CustomLightInfo
{
	float3 lightColor;
	float3 direction;
	float fallOffStart;	
	float fallOffEnd;
	float3 worldPosition;
	float spotAngle;
};


/// <summary>
/// 라이트 정보를 행렬로 출력
/// </summary>
/// <returns>
/// 1행 color rgb, falloff(감쇠) start
/// 2행 direction xyz, falloff(감쇠) end
/// 3행 worldposition xyz, spot Angle
/// 4행 0,0,0,0 
/// </returns>
CustomLightInfo ScriptableMainLight(float4 lightV0, float4 lightV1, float4 lightV2, float4 lightV3)
{
	CustomLightInfo o;
	float4x4 mat;
	MatrixFromVectorRow4x4(lightV0, lightV1, lightV2, lightV3, mat);
	o.direction = -mat[1].xyz;
	o.lightColor = mat[0].xyz;
	o.fallOffStart = 0;
	o.fallOffEnd = 0;
	o.spotAngle = 0;
	o.worldPosition = ZERO_VECTOR3;
	return o;
}

/// <summary>
/// 라이트 정보를 행렬로 출력
/// </summary>
/// <returns>
/// 1행 color rgb, falloff(감쇠) start
/// 2행 direction xyz, falloff(감쇠) end
/// 3행 worldposition xyz, spot Angle
/// 4행 0,0,0,0 
/// </returns>
CustomLightInfo ScriptablePointLight(float4 lightV0, float4 lightV1, float4 lightV2, float4 lightV3)
{
	CustomLightInfo o;
	float4x4 mat;
	MatrixFromVectorRow4x4(lightV0, lightV1, lightV2, lightV3, mat);
	o.direction = 0;
	o.lightColor = mat[0].xyz;
	o.fallOffStart = mat[0].w;
	o.fallOffEnd = mat[1].w;
	o.spotAngle = 0;
	o.worldPosition = mat[2].xyz;
	return o;
}


inline float3 CelShadeLightColor(float3 light, float celShadow, float halfLambert)
{
	float3 darkDevidedLight = light * 0.1;
	float3 lightenDevidedLight = light * 0.9;	
	float lightMax = max(max(light.r, light.g), light.b);
	float3 lightMaxLerp = lerp(0, 0.8, lightMax);
	float3 darkDevidedLightColor = darkDevidedLight + lightMaxLerp;
	float3 lightMaxColor = float3(lightMax, lightMax, lightMax);

	
	return lerp(darkDevidedLight, lightenDevidedLight, smoothstep(0.66, 1.2, celShadow)) * 0.4 + celShadow * halfLambert * darkDevidedLightColor;
	
}

inline float CalculateCelShadow(float midPoint, float softness, float shadow, float bright, float ndl)
{
	float clampSoftness = clamp(0.01, 1, softness);
	float celshadow = saturate(lerp(0, shadow, saturate(lerp(-2, 2, smoothstep(midPoint - clampSoftness, midPoint + clampSoftness, ndl)))));
	float adjustedBright = lerp(bright, 1, celshadow);
	return adjustedBright;
}

inline float3 SpecularInten(float3 normal_WS, float3 view_WS, float specularInten) {
	Light mainLight = GetMainLight();
	float3 halfVector = normalize((view_WS + mainLight.direction));
	float ndh = dot(normal_WS, halfVector);	
	if (specularInten > 0) {
		float specular = max(0, pow(ndh * specularInten, SPECULAR_GLOSSNESS));
		//specular = smoothstep(0.005, 0.01, specular);
		return mainLight.color.rgb * specular;
	}
	else {
		return float3(0,0,0);
	}
}



inline float HalfLambert(float3 light_WS, float3 position_WS, float pivot, float relativeScale )
{	
	float3 position = TransformWorldToObject(float3(position_WS.x, position_WS.y + 0, position_WS.z));
	float3 light = normalize(TransformWorldToObjectDir(light_WS) * float3(1.2, 1.8, 1.8));

	//float halfLambert = smoothstep(0, 1, saturate(clamp(lerp(1, lerp(0.5, 1.2, dot(light, position)), 1.65), 0.1, 1.5) * 0.5 + 0.5));	
	float halfLambert = smoothstep(0, 1, saturate(lerp(0.1, 0.6, dot(light / relativeScale, position) ) + 0.5));
	return halfLambert;
}


inline float LightAttenuation(float fallStart, float fallEnd, float distance, float3 lightDir, float3 worldNormal)
{	
	float o = saturate((fallEnd - distance) / (fallEnd - fallStart));
	//o = smoothstep(-0.2, 2, o);
	o *= saturate(max(0, dot(normalize(lightDir), normalize(worldNormal)) * -1));
	o = smoothstep(0, 0.35, o);	
	return o;
}

inline void UnityLight(float3 position_ws, float3 normal_ws, 
	inout float3 lightDir, inout float3 lColor, inout float atten,
	inout float3 addColor, inout float shadowAtten) {

	Light mainLight = GetMainLight();
	ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
	half4 shadowParams = GetMainLightShadowParams();
	shadowAtten = smoothstep(0, 0.5, (SampleShadowmap(TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), TransformWorldToShadowCoord(position_ws), shadowSamplingData, shadowParams, false)));
	lightDir = mainLight.direction;
	lColor = max(ZERO_VECTOR3, mainLight.color);
	addColor = 0;
	atten = 0;
	
	int pixelLightCount = GetAdditionalLightsCount();
	for (int i = 0; i < pixelLightCount; ++i) {
		Light light = GetAdditionalLight(i, position_ws);				
		addColor += max(ZERO_VECTOR3, light.color * light.distanceAttenuation * light.shadowAttenuation);
	}
	
}

inline void CustomLight(float3 position_ws, float3 normal_ws, 
	CustomLightInfo direction, CustomLightInfo pLight[MAX_POINTLIGHT],
	inout float3 dir, inout float3 lColor, inout float atten, inout float3 addColor, inout float shadowAtten)
{
	Light mainLight = GetMainLight();
	ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
    half4 shadowParams = GetMainLightShadowParams();
    shadowAtten = smoothstep(0,0.5,(SampleShadowmap(TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), TransformWorldToShadowCoord(position_ws), shadowSamplingData, shadowParams, false)));
	dir = mainLight.direction;
	lColor = max(ZERO_VECTOR3, mainLight.color);
	addColor = 0;
	atten = 0;
	//shadowAtten = 0;
	for (int index = 0; index < MAX_POINTLIGHT; ++index) 
	{
		CustomLightInfo info = pLight[index];
		float3 pointLightDir = position_ws - info.worldPosition;
		float addAtten = LightAttenuation(info.fallOffStart, info.fallOffEnd, length(pointLightDir), pointLightDir, normal_ws);
		addColor += max(ZERO_VECTOR3, info.lightColor.rgb) * addAtten;		
		//ndl 계산으로 노멀이 라이트 중점에서 90도 이상 벌어지면 라이트를 넣지 않는기능인데 필요할지..
		//float3 NdotL = saturate(max(0, dot(position_ws - info.worldPosition, normal_ws)));
		//float3 addLightShade = saturate(lerp(0, 1, NdotL));
		//addColor += info.lightColor.rgb * addAtten * smoothstep(0, 0.35, addLightShade);
	}
}

float4 UnityLightShadedColor(float3 position_WS, float3 normal_WS, float3 view_WS, float4 mainTexColor, float4 indirectionInfo
	, float celMid, float celSoft, float shadowBright, float pivotY, float relativeScale) {

	float3 lightDir_WS = 0;
	float3 lightColor = 0;
	float lightAtten = 0;
	float3 lightAddColor = 0;
	float shadowAtten = 0;
	UnityLight(position_WS, normal_WS, lightDir_WS, lightColor, lightAtten, lightAddColor, shadowAtten);

	float3 reflection = reflect(-view_WS, normal_WS);
	float VdotN = dot(view_WS, normal_WS);
	float halfLambert = HalfLambert(lightDir_WS, position_WS, pivotY, relativeScale);
	float celShadow = CalculateCelShadow(celMid, celSoft, shadowAtten, shadowBright, dot(normal_WS, lightDir_WS));
	
	float4 outdiffuse = lerp(pow(mainTexColor, 2), mainTexColor, halfLambert);
	float3 celightColor = CelShadeLightColor(lightColor + lightAddColor, celShadow, halfLambert) * (indirectionInfo.rgb + indirectionInfo.aaa);

	outdiffuse.rgb *= celightColor;
	return outdiffuse;
}


float4 CustomLightShadedColor ( 
float3 position_WS, float3 normal_WS, float3 view_WS, float4 mainTexColor, float4 indirectionInfo, 
float4 dirLightV0, float4 dirLightV1, float4 dirLightV2, float4 dirLightV3, float4 ptLight0V0, float4 ptLight0V1, float4 ptLight0V2, float4 ptLight0V3, 
float4 ptLight1V0, float4 ptLight1V1, float4 ptLight1V2, float4 ptLight1V3, float4 ptLight2V0, float4 ptLight2V1, float4 ptLight2V2, float4 ptLight2V3, 
float4 ptLight3V0, float4 ptLight3V1, float4 ptLight3V2, float4 ptLight3V3, float celMid, float celSoft, float shadowBright, float pivotY, float relativeScale) 
{	
	float4 returnColor = 0;
    float3 lightDir_WS = 0;
    float3 lightColor = 0;
    float lightAtten = 0;
    float3 lightAddColor = 0;
    float shadowAtten = 0;

	CustomLightInfo directionL = ScriptableMainLight(dirLightV0, dirLightV1, dirLightV2, dirLightV3);
	CustomLightInfo pointLights[MAX_POINTLIGHT];
	pointLights[0] = ScriptablePointLight(ptLight0V0, ptLight0V1, ptLight0V2, ptLight0V3);
	pointLights[1] = ScriptablePointLight(ptLight1V0, ptLight1V1, ptLight1V2, ptLight1V3);
	pointLights[2] = ScriptablePointLight(ptLight2V0, ptLight2V1, ptLight2V2, ptLight2V3);
	pointLights[3] = ScriptablePointLight(ptLight3V0, ptLight3V1, ptLight3V2, ptLight3V3);
	

	CustomLight(position_WS, normal_WS, directionL, pointLights, lightDir_WS, lightColor, lightAtten, lightAddColor, shadowAtten);
	
	float3 reflection = reflect(-view_WS, normal_WS);
    float VdotN = dot(view_WS, normal_WS);	
	float halfLambert = HalfLambert(lightDir_WS, position_WS, pivotY, relativeScale);
	float celShadow = CalculateCelShadow(celMid, celSoft, shadowAtten, shadowBright, dot(normal_WS, lightDir_WS));
	//return float4(shadowAtten, shadowAtten, shadowAtten, 1);
	float4 outdiffuse = lerp(pow(mainTexColor,2), mainTexColor, halfLambert);
	float3 celightColor = CelShadeLightColor(lightColor, celShadow, halfLambert) * (indirectionInfo.rgb + indirectionInfo.aaa);

	outdiffuse.rgb *= celightColor;
	outdiffuse.rgb += lightAddColor;
	//return 0;
	return outdiffuse;
}

#endif