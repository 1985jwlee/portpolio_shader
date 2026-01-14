Shader "URPTimeDefenders/HideOutlineThickness"
{
    Properties
    {
        _HideOutlineThickness("", Range(0.001, 0.05)) = 0.01
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent+1000"
            "RenderType" = "Transparent"
        }

        Pass
        {
            Cull front
            ZWrite Off
            ZTest Greater
            Blend SrcAlpha OneMinusSrcAlpha
            Stencil
            {
                //Ref[_Stencil]
                Ref 8
                Comp Equal
                Pass incrWrap
                ZFail Keep
            }
            Name "HideOutlineThickness"
            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float _HideOutlineThickness;
            CBUFFER_END

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 position_CS : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                float3 offset = _HideOutlineThickness * v.normal;
                o.position_CS = TransformObjectToHClip(v.vertex.xyz - offset);
                return o;
            }

            half4 frag() : SV_Target
            {                
                return half4(0,0,0,0);
            }

            ENDHLSL
        }
    }
}
