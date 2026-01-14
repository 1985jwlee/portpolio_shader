Shader "URPTimeDefenders/UnitTransparent"
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
        _TilingSpeed("Tiling Speed", Vector) = (0,0,0,0)

        [HideInInspector] _ShadowOffsetBody("", Float) = 0
        [HideInInspector] _CutsceneAmbientTexture ("",2D) = "white"{}
        [HideInInspector] _AmbientRamp ("_Ambient Ramp Texture", 2D) = "white"{}
        [HideInInspector] _ModelHeight("Model Height", Float) = 1

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
        
        
        
/// 1행 color rgb, falloff(감쇠) start
/// 2행 direction xyz, falloff(감쇠) end
/// 3행 worldposition xyz, spot Angle
/// 4행 0,0,0,0 
        [HideInInspector]_UseLightMapper("", Float) = 0
        [HideInInspector]_DirectionLightV0("", Vector) = (0,0,0,0)
        [HideInInspector]_DirectionLightV1("", Vector) = (0,0,0,0)
        [HideInInspector]_DirectionLightV2("", Vector) = (0,0,0,0)
        [HideInInspector]_DirectionLightV3("", Vector) = (0,0,0,0)

        [HideInInspector]_PointLight0_V0("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight0_V1("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight0_V2("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight0_V3("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight1_V0("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight1_V1("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight1_V2("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight1_V3("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight2_V0("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight2_V1("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight2_V2("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight2_V3("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight3_V0("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight3_V1("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight3_V2("", Vector) = (0,0,0,0)
        [HideInInspector]_PointLight3_V3("", Vector) = (0,0,0,0)

        [Space(50)]
        [Header(Toon Rendering)]
        [Space(10)]
        _MaskTexture("Mask R(metal)G(hair)B(rim)A(emissive)", 2D) = "black"{}        
        _NormalTexture("NormalTexture", 2D) = "bump"{}
        [HideInInspector]_ShadowBrightness("ShadowBrightness", Range(0,1)) = 0
        [HideInInspector]_CelMidPoint("CelMidPoint", Range(0,1)) = 0
        [HideInInspector]_CelSoftness("CelSoftness", Range(0,1)) = 0
        [HideInInspector]_IndirectColor("IndirectColor", Color) =(0.2,0.2,0.2,1)
        [HideInInspector]_IndirectMulti("IndirectMultiply", Float) = 0.1
        [HideInInspector]_MatCap("MatCapCube", CUBE) = ""{}
        [HideInInspector]_MatCapColor("MatCapColor", Color) = (0,0,0,0)
        [HideInInspector]_MatCapPow("MatCapPower", Float) = 1
        [HideInInspector]_EmitColor("EmissiveColor", Color) = (0,0,0,0)
        [HideInInspector]_EmitIntensity("EmissiveIntensity", Float) = 0
        [HideInInspector]_RimPower("RimPower", Float) = 0
        [HideInInspector]_IsHair("IsHair On=over 0 else Off", Float) = 0
        [HideInInspector]_HairRingCube("HairRingCube", CUBE) = ""{}
        [HideInInspector]_HairRingColor("HairRingColor", Color) = (0,0,0,0)
        [HideInInspector]_HairRingPow("HairRingPower", Float) = 0
        [HideInInspector]_ShadePivot("DirectionalLightPivot", Float) = 0
		[HideInInspector] _RelativeScale("", Float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }

        LOD 300

        Pass
        {
            Name "BodyShaderMain"
            Cull [_Cull]
            Blend SrcAlpha OneMinusSrcAlpha
            Stencil
			{
				Ref[_Stencil]
				Comp Always
				Pass Replace
				ZFail Keep
			}

            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#define UNIT_BODY_SHADER
#include "../Includes/UnitVariable.hlsl"
#include "../Includes/Functions.hlsl"
#include "../Includes/CustomLight.hlsl"


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
                o.texcoord += _TilingSpeed.xy * _Time.y;
                o.normal_WS = TransformObjectToWorldNormal(v.normal);
                o.position_WS = TransformObjectToWorld(v.vertex.xyz);
                o.view_WS = WorldSpaceViewDir(o.position_WS.xyz);
                o.texcoord_SS = ComputeScreenPos(v.vertex);
                return o;
            }

            float4 frag(v2f i) : SV_Target {
                UNITY_SETUP_INSTANCE_ID(i);
                float4 mainTexColor = TEX_COLOR(_MainTex, i.texcoord);
                if(_IsFace > 0){
                    clip(mainTexColor.a - 0.9);
                }                

                if(_UseLightMapper  == 1){
                    mainTexColor = CustomLightShadedColor(i.position_WS, i.normal_WS, i.view_WS, mainTexColor, float4(_IndirectColor.rgb, _IndirectMulti), _DirectionLightV0, _DirectionLightV1, _DirectionLightV2, _DirectionLightV3, _PointLight0_V0, _PointLight0_V1, _PointLight0_V2, _PointLight0_V3, _PointLight1_V0, _PointLight1_V1, _PointLight1_V2, _PointLight1_V3, _PointLight2_V0, _PointLight2_V1, _PointLight2_V2, _PointLight2_V3, _PointLight3_V0, _PointLight3_V1, _PointLight3_V2, _PointLight3_V3, _CelMidPoint, _CelSoftness, _ShadowBrightness, _ShadePivot , _RelativeScale);
                }
                else if (_UseLightMapper == 2) {
                    mainTexColor = UnityLightShadedColor(i.position_WS, i.normal_WS, i.view_WS, mainTexColor, float4(_IndirectColor.rgb, _IndirectMulti), _CelMidPoint, _CelSoftness, _ShadowBrightness, _ShadePivot, _RelativeScale);
                }

                if(_NeedRimLight > 0){
                    float4 rimTexColor = TEX_COLOR(_RimMap, i.texcoord);
                    float fresnel = pow(1 - saturate(dot(i.view_WS, i.normal_WS)), 15);
                    mainTexColor.rgb += fresnel * rimTexColor.rgb * _RimColor.rgb;
                }

                float4 maskTex = TEX_COLOR(_MaskTexture, i.texcoord);
                mainTexColor.rgb += SpecularInten(i.normal_WS, i.view_WS, maskTex.r);

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
                return output;
            }

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster"}
            Cull Back
            ZWrite On
            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma prefer_hlslcc gles
            #pragma target 2.0

            float LerpWhiteTo(float b, float t)
            {
                float oneMinusT = 1.0 - t;
                return oneMinusT + b * t;
            }
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

            float3 _LightDirection;

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float2 texcoord     : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv           : TEXCOORD0;
                float4 positionCS   : SV_POSITION;
            };

            float4 GetShadowPositionHClip(Attributes input)
            {
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

                float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

            #if UNITY_REVERSED_Z
                positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
            #else
                positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
            #endif

                return positionCS;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);

                output.uv = input.texcoord;
                output.positionCS = GetShadowPositionHClip(input);
                return output;
            }

            half4 frag(Varyings input) : SV_TARGET
            {            
                return 0;
            }
            ENDHLSL
        }


        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode"="DepthOnly"}
            ZWrite On
            ColorMask 0
            Cull Back

            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma target 2.0
#pragma vertex DepthOnlyVertex
#pragma fragment DepthOnlyFragment
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "../Includes/UnitVariable.hlsl"
#include "../Includes/Functions.hlsl"
            

            CBUFFER_START(UnityPerMaterial)
            CBUFFER_END

            v2f DepthOnlyVertex(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.position_CS = TransformObjectToHClip(v.vertex.xyz);
                return o;
            }

            half4 DepthOnlyFragment(v2f i) : SV_TARGET
            {   
                UNITY_SETUP_INSTANCE_ID(i);
                return 0;
            }
            ENDHLSL

        }    
    }
}
