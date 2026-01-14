
Shader "_TimeDependers/TdStageBackground" 
{
	Properties
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		[HideInInspector]_AlphaCutOut("", Range(0,1)) = 0.9
	}
	SubShader 
	{
		Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "AlphaTest"
            "RenderType" = "Geometry"
        }
		
		Blend One Zero

		Pass
		{			
			Cull Back
			Name "Shadow"
			HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			struct appdata{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 position_CS : SV_POSITION;
				float2 texcoord : TEXCOORD1;
			};

			CBUFFER_START(UnityPerMaterial)
			TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
			float4 _MainTex_ST;
			float _AlphaCutOut;
			CBUFFER_END

			v2f vert(appdata v)
			{
				v2f o;
				o.position_CS = TransformObjectToHClip(v.vertex.xyz);
				TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord = (v.texcoord * _MainTex_ST.xy) + _MainTex_ST.zw;
				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
				half4 c = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
				clip(c.a - _AlphaCutOut);
				return c;
			}
			ENDHLSL
		}

	}
}
