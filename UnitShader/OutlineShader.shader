Shader "URPTimeDefenders/OutlineShader"
{
    Properties
    {
        _OutlineTex("OutlineTexture", 2D) = "black"{}
        _IsFace("IsFace", Range(0,1)) = 0
        _ClipAll("Clip All", Float) = 0
        _HideOutline("Hide Outline", Float) = 0
        [HideInInspector]_OutlineWidth("", Range(0,10000)) = 10
        [HideInInspector]_OutlineColor("", Color) = (1,1,1,1)      
        [HideInInspector]_OutlineLerp("", Range(0,1)) = 0
        [HideInInspector]_OutlineMultiply("", Float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Geometry-1"
            "RenderType" = "Opaque"
        }

        Cull Front
        ZWrite On        
        ZTest Less
        Name "Outline"

        Pass
        {
            
            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#define UNIT_OUTLINE_SHADER
#include "../Includes/UnitVariable.hlsl"
#include "../Includes/Functions.hlsl"

            v2f vert(appdata v) {
                v2f o;                
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);

                float4 clipPosition = TransformObjectToHClip(v.vertex.xyz);                
                float3 clipNormal = TransformObjectToHClipDir(normalize(v.normal));
                float targetScreenWidth = 3120;
                float targetScreenHeight = 1440;
                float2 retScreenParam = float2(targetScreenWidth, targetScreenHeight) * ((targetScreenWidth) / (targetScreenHeight));
                retScreenParam *= 5;

                float2 offset = normalize(clipNormal.xy) / retScreenParam * _OutlineWidth * clipPosition.w;
                float vcOffset = clamp(v.color.r, 0, 1);                
                clipPosition.xy += offset * vcOffset * _OutlineMultiply;                          
             

                o.position_CS = clipPosition;
                o.texcoord = v.texcoord;
                o.color = v.color;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {                
                if(_HideOutline > 0){
                    clip(-1);
                }

                if(_ClipAll > 0)
                {
                    clip(-1);
                }

                if (_IsFace > 0) {
                    clip(-1);
                }

                clip(i.color.r - 0.1);
                return lerp(0, _OutlineColor, _OutlineLerp);

            }

            ENDHLSL
        }
        
    }
}
