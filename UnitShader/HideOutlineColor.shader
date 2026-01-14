Shader "URPTimeDefenders/HideOutlineColor"
{
    Properties
    {
        _HideOutlineColor("", Color) = (0,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent+1001"
            "RenderType" = "Transparent"
        }

        Pass
        {
            Cull Front
            ZWrite Off
            ZTest Greater
            Blend SrcAlpha OneMinusSrcAlpha

            Stencil
            {
                Ref 8
                Comp Equal
                Pass Keep
                ZFail Keep
            }
            Name "HideOutlineColor"
            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _HideOutlineColor;
            CBUFFER_END

            struct appdata {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 position_CS : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.position_CS = TransformObjectToHClip(v.vertex.xyz);
                return o;
            }

            half4 frag() : SV_Target
            {                
                return _HideOutlineColor;
            }

            ENDHLSL
        }
    }
}
