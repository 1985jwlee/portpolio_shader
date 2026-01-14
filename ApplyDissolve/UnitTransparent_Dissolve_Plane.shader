///LOD 300 -> OutGameShader  LOD 200 -> InGameShader
Shader "URPTimeDefenders/Unit_Dissolve_Plane"
{
    Properties
    {
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull mode", Float) = 2
        _MainTex ("Texture", 2D) = "white" {}
        _EmissiveMap("Emissive Texture", 2D) = "black" {}
        _NeedRimLight("NeedRimLight", Range(0,1)) = 0
        _RimMap ("Rim Map", 2D) = "white" {}
        _RimColor("Rim Color", Color) = (0,0,0,0)
        
        _IsFace("IsFace", Range(0,1)) = 0

        [HideInInspector] _CutsceneAmbientTexture ("",2D) = "white"{}
        [HideInInspector] _AmbientRamp ("_Ambient Ramp Texture", 2D) = "white"{}
        [HideInInspector] _ModelHeight("Model Height", Float) = 1
        [HideInInspector] _ShadowOffsetBody("", Float) = 0
        
        [HideInInspector] _FacialUV("", Vector) = (0,0,0,0)
        [HideInInspector] _FacialRate("", Range(0,1)) = 1
        [HideInInspector] _AmbientTexture("", 2D) = "white"{}
        [HideInInspector] _AmbientUV("", Vector) = (0,0,0,0)
        [HideInInspector] _GrayScaleLerp("", Range(0, 1)) = 0
        [HideInInspector] _BodyColorLerp("", Range(0,1)) = 0
        [HideInInspector] _PreMulBodyColor("", Color) = (1,1,1,1)
        [HideInInspector] _PreMulBodyValue("", Range(0.5, 2)) = 1
        [HideInInspector] _AddBodyColor("", Color) = (0,0,0,0)
		[HideInInspector] _BodyColor("", Color) = (1,1,1,1)
        [HideInInspector] _OneToneColor("", Color) = (1,1,1,1)
        [HideInInspector] _Stencil("Stencil ID", Int) = 0

        //Advanced Dissolve
		[HideInInspector] _DissolveCutoff("Dissolve", Range(0,1)) = 0.25
		//Mask		
		[HideInInspector][Enum(X,0,Y,1,Z,2)]                                                _DissolveMaskAxis("Axis", Float) = 0
		[HideInInspector][Enum(World,0,Local,1)]                                            _DissolveMaskSpace("Space", Float) = 0
		[HideInInspector]																   _DissolveMaskOffset("Offset", Float) = 0
																		   _DissolveMaskInvert("Invert", Float) = -1		
		[HideInInspector]  _DissolveMaskPosition("", Vector) = (0,0,0,0)
		[HideInInspector]  _DissolveMaskNormal("", Vector) = (1,0,0,0)
		[HideInInspector]  _DissolveMaskRadius("", Float) = 1
		//Alpha Source		
		[HideInInspector] _DissolveMap1("", 2D) = "white" { }
		[HideInInspector][UVScroll] _DissolveMap1_Scroll("", Vector) = (0,0,0,0)
		[HideInInspector] _DissolveMap1Intensity("", Range(0, 1)) = 1
		[HideInInspector][Enum(Red, 0, Green, 1, Blue, 2, Alpha, 3)] _DissolveMap1Channel("", INT) = 3
		[HideInInspector] _DissolveMap2("", 2D) = "white" { }
		[HideInInspector][UVScroll] _DissolveMap2_Scroll("", Vector) = (0,0,0,0)
		[HideInInspector] _DissolveMap2Intensity("", Range(0, 1)) = 1
		[HideInInspector][Enum(Red, 0, Green, 1, Blue, 2, Alpha, 3)] _DissolveMap2Channel("", INT) = 3
		[HideInInspector] _DissolveMap3("", 2D) = "white" { }
		[HideInInspector][UVScroll] _DissolveMap3_Scroll("", Vector) = (0,0,0,0)
		[HideInInspector] _DissolveMap3Intensity("", Range(0, 1)) = 1
		[HideInInspector][Enum(Red, 0, Green, 1, Blue, 2, Alpha, 3)] _DissolveMap3Channel("", INT) = 3
		[HideInInspector][Enum(Multiply, 0, Add, 1)]  _DissolveSourceAlphaTexturesBlend("Texture Blend", Float) = 0
		[HideInInspector]							  _DissolveNoiseStrength("Noise", Float) = 0.1
		[HideInInspector][Enum(UV0,0,UV1,1)]          _DissolveAlphaSourceTexturesUVSet("UV Set", Float) = 0		
		[HideInInspector][Enum(World,0,Local,1)]                        _DissolveTriplanarMappingSpace("Mapping", Float) = 0
		[HideInInspector]                                               _DissolveMainMapTiling("", FLOAT) = 1
		//Edge
		[HideInInspector]                                       _DissolveEdgeWidth("Edge Size", Range(0,1)) = 0.25
		[HideInInspector][Enum(Cutout Source,0,Main Map,1)]     _DissolveEdgeDistortionSource("Distortion Source", Float) = 0
		[HideInInspector]                                       _DissolveEdgeDistortionStrength("Distortion Strength", Range(0, 2)) = 0
		//Color
		[HideInInspector]                _DissolveEdgeColor("Edge Color", Color) = (0,1,0,1)
		[HideInInspector][PositiveFloat] _DissolveEdgeColorIntensity("Intensity", FLOAT) = 0
		[HideInInspector][Enum(Solid,0,Smooth,1, Smooth Squared,2)]      _DissolveEdgeShape("Shape", INT) = 2		
		[HideInInspector][NoScaleOffset]								 _DissolveEdgeTexture("Edge Texture", 2D) = "white" { }
		[HideInInspector][Toggle]										 _DissolveEdgeTextureReverse("Reverse", FLOAT) = 0
		[HideInInspector]												 _DissolveEdgeTexturePhaseOffset("Offset", FLOAT) = 0
		[HideInInspector]												 _DissolveEdgeTextureAlphaOffset("Offset", Range(-1, 1)) = 0
		[HideInInspector]												 _DissolveEdgeTextureMipmap("", Range(0, 10)) = 1
		[HideInInspector][Toggle]										 _DissolveEdgeTextureIsDynamic("", Float) = 0
		[HideInInspector][PositiveFloat] _DissolveGIMultiplier("GI Strength", Float) = 1
		//Meta
		[HideInInspector] _Dissolve_ObjectWorldPos("", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent+1"
            "RenderType" = "Transparent"
        }

        

        Pass
        {
            Name "BodyShaderDissolveOrigin"
            Cull [_Cull]
            Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#define REDEFINE_BODYSHADER_VARIABLE
#define UNIT_BODY_SHADER
#define _ALPHABLEND_ON
#define _DISSOLVEALPHASOURCE_CUSTOM_MAP
#define _DISSOLVEMASK_PLANE
#define CUSTOM_VERT_STRUCT
#include "../Includes/UnitVariable.hlsl"
#include "../Includes/Functions.hlsl"


            CBUFFER_START(UnityPerMaterial)
            DECLARE_TEXTURE_2D_ST(_MainTex)
            DECLARE_TEXTURE_2D_ST(_EmissiveMap)
            float _NeedRimLight;
            DECLARE_TEXTURE_2D_ST(_RimMap);
            float4 _RimColor;
            float _IsFace;
            float4 _FacialUV;
            float _FacialRate;
            DECLARE_TEXTURE_2D(_AmbientTexture)
            float4 _AmbientUV;
            float _GrayScaleLerp; float _BodyColorLerp;
            float4 _PreMulBodyColor; float _PreMulBodyValue;
            float4 _AddBodyColor; float4 _BodyColor; float4 _OneToneColor;
            DECLARE_TEXTURE_2D(_CutsceneAmbientTexture)
            DECLARE_TEXTURE_2D(_AmbientRamp)
            float _ModelHeight;
            float _ShadowOffsetBody;
            CBUFFER_END

#include "../Includes/AdvancedDissolve/hlslinc/Variables.hlsl"
#include "../Includes/AdvancedDissolve/hlslinc/AdvancedDissolve.hlsl"

            struct v2f {
                float4 position_CS : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normal_OS : NORMAL;    
                float3 normal_WS : TEXCOORD1;
                float3 position_WS : TEXCOORD2;
                float3 view_WS : TEXCOORD3;
                float4 texcoord_SS : TEXCOORD4;
                ADVANCED_DISSOLVE_DATA(5)
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


            v2f vert(appdata v){
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.position_CS = TransformObjectToHClip(v.vertex.xyz);
                o.normal_OS = v.normal;
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                if(_IsFace > 0){
                    o.texcoord += _FacialUV.xy;
                }
                
                o.normal_WS = TransformObjectToWorldNormal(v.normal);
                o.position_WS = TransformObjectToWorld(v.vertex.xyz);
                o.view_WS = WorldSpaceViewDir(o.position_WS.xyz);
                o.texcoord_SS = ComputeScreenPos(v.vertex);
                ADVANCED_DISSOLVE_INIT_DATA(o.position_CS, o.texcoord.xy, o.texcoord.xy, o)
                return o;
            }

            float4 frag(v2f i) : SV_Target {
                UNITY_SETUP_INSTANCE_ID(i);

                float alpha = AdvancedDissolveGetAlpha(i.texcoord, i.position_WS, i.normal_WS, i.dissolveUV).a;
                float3 dissolveAlbedo = 0;
				float3 dissolveEmission = 0;
                DoDissolveClip(alpha);

                float4 mainTexColor = float4(0,0,0,0);
                mainTexColor = TEX_COLOR(_MainTex, i.texcoord);
                if(_IsFace > 0){
                    clip(mainTexColor.a - 0.9);
                }
                
                if(_NeedRimLight > 0){
                    float4 rimTexColor = TEX_COLOR(_RimMap, i.texcoord);
                    float fresnel = pow(1 - saturate(dot(i.view_WS, i.normal_WS)), 15);
                    mainTexColor.rgb += fresnel * rimTexColor.rgb * _RimColor.rgb;
                }
                mainTexColor *= (_PreMulBodyValue * _PreMulBodyColor);
                mainTexColor.rgb += _AddBodyColor.rgb;
                float4 ambientTexcolor = TEX_COLOR(_AmbientTexture, _AmbientUV.xy);
                mainTexColor.rgb *= ambientTexcolor.rgb;
                

                float4 emissiveTexColor = TEX_COLOR(_EmissiveMap, i.texcoord);
                mainTexColor.rgb += emissiveTexColor.rgb;
                float4 lerpColor = lerp(mainTexColor, _BodyColor, _BodyColorLerp);
                float4 grayTone = grayScale(lerpColor);                
                float4 oneTone = lerp(lerpColor, grayTone * _OneToneColor, _GrayScaleLerp);
                
                float2 screenCoord = i.texcoord_SS.xy / i.texcoord_SS.w;
                float4 cutsceneAmb = TEX_COLOR(_CutsceneAmbientTexture, screenCoord);
                float lerpHeight = lerp(0, 1, (i.position_WS.y - _ShadowOffsetBody) / (_ModelHeight));
                float4 heightRamp = TEX_COLOR(_AmbientRamp, float2(0.5, lerpHeight));                
                float4 output = float4(oneTone.rgb * cutsceneAmb.rgb * heightRamp.rgb, oneTone.a);


                    
				float dissolveBlend = DoDissolveAlbedoEmission(alpha, dissolveAlbedo, dissolveEmission, i.texcoord, output.rgb);                    
                float3 outputColor = lerp(output.rgb, dissolveEmission, dissolveBlend);
                    
                return float4(outputColor, output.a);
                
            }

            ENDHLSL
        }
    }
}
