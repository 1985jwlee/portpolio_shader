Shader "URPTimeDefenders/ShadowShader"
{
    Properties
    {
        [HideInInspector]_ShadowClip("", Float) = 0
        [HideInInspector]_ShadowColor("", Color) = (0.5,0.5,0.5,0.5)
        [HideInInspector]_ShadowOffset("", Float) = 0
        [HideInInspector]_LightDirection("", Vector) = (0.4,-1,0.5,0)
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
            Cull Back
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Stencil
			{
				Ref 0
				Comp Equal
				Pass IncrWrap
				ZFail Keep
			}
            Name "Shadow"
            HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#define UNIT_SHADOW_SHADER
#include "../Includes/UnitVariable.hlsl"
#include "../Includes/Functions.hlsl"

            v2f vert(appdata v) {
                v2f o;                
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.position_CS = followShadowVertex(v.vertex, _LightDirection, _ShadowOffset + 0.02);
                return o;
            }

            half4 frag() : SV_Target
            {                
                if(_ShadowClip > 0){
                    clip(-1);
                }
                return _ShadowColor;
            }

            ENDHLSL
        }
        
    }
}
