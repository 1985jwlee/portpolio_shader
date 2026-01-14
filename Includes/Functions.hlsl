#ifndef FUNCTION_INCLUDED
#define FUNCTION_INCLUDED

#ifdef UNIVERSAL_PIPELINE_CORE_INCLUDED

#define ZERO_VECTOR4 float4(0,0,0,0)
#define ZERO_VECTOR3 float3(0,0,0)
#define ZERO_VECTOR2 float2(0,0)
#define ONE_VECTOR4 float4(1,1,1,1)
#define ONE_VECTOR3 float3(1,1,1)
#define ONE_VECTOR2 float2(1,1)

void MatrixFromVectorRow4x4(float4 a, float4 b, float4 c, float4 d, 
	out float4x4 result4x4)
{
	result4x4 = float4x4(a, b, c, d);
}

void MatrixFromVectorColumn4x4(float4 a, float4 b, float4 c, float4 d, 
	out float4x4 result4x4)
{
	result4x4 = float4x4(a.x, b.x, c.x, d.x, a.y, b.y, c.y, d.y, a.z, b.z, c.z, d.z, a.w, b.w, c.w, d.w);
}

float3 WorldSpaceViewDir(float3 positionWS)
{
	if(unity_OrthoParams.w == 0)
	{
		return SafeNormalize(_WorldSpaceCameraPos - positionWS);
	}

	float4x4 viewMatrix = GetWorldToViewMatrix();
	return SafeNormalize(viewMatrix[2].xyz);
}

float3 TransformObjectToHClipDir(float3 direction)
{
	return TransformWorldToHClipDir(TransformObjectToWorldNormal(direction), true);
}

float4 followShadowVertex(float4 vertex, float4 litDir, float height) 
{
	float3 vPosWorld = TransformObjectToWorld(vertex.xyz);
	float4 lightDirection = -normalize(float4(litDir.xyz, 0));
	float opposite = vPosWorld.y - height;
	float cosTheta = -lightDirection.y;
	float hypotenuse = opposite / cosTheta;
	float3 vPos = vPosWorld + (lightDirection.xyz * hypotenuse);
	return mul(UNITY_MATRIX_VP, float4(vPos.x, height, vPos.z, 1));
}

float4 grayScale(float4 color) {
	float4 temp = color;
	temp.rgb = dot(temp.rgb, float3(0.3, 0.59, 0.11));
	return temp;
}

#endif

#endif