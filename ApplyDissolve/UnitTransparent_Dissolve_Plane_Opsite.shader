///LOD 300 -> OutGameShader  LOD 200 -> InGameShader
Shader "URPTimeDefenders/Unit_Dissolve_Plane_Opsite"
{
    Properties
    {
        [HideInInspector][Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull mode", Float) = 2
        [HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        //Advanced Dissolve
		[HideInInspector] _DissolveCutoff("Dissolve", Range(0,1)) = 0.25
		//Mask		
		[HideInInspector][Enum(X,0,Y,1,Z,2)]                                                _DissolveMaskAxis("Axis", Float) = 0
		[HideInInspector][Enum(World,0,Local,1)]                                            _DissolveMaskSpace("Space", Float) = 0
		[HideInInspector]																   _DissolveMaskOffset("Offset", Float) = 0
		[HideInInspector]																   _DissolveMaskInvert("Invert", Float) = 1		
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
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        

        Pass
        {
            Name "BodyShaderDissolveOpsite"
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

                float4 output = TEX_COLOR(_MainTex, i.texcoord);


                float dissolveBlend = DoDissolveAlbedoEmission(alpha, dissolveAlbedo, dissolveEmission, i.texcoord, output.rgb);                    
                float3 outputColor = lerp(output.rgb, dissolveEmission, dissolveBlend);
                    
                return float4(outputColor, output.a);
            }

            ENDHLSL
        }
    }
}
