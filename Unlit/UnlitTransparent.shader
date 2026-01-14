Shader "URPTimeDefenders/UnlitTransparent" 
{
	Properties
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Color("Main Color", Color) = (1,1,1,1)
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4
		[Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull mode", Float) = 2
		_UseAlphaClip("Use Alpha Clip", Range(0,1)) = 0
		[Enum(None,0,Alpha,1,Red,8,Green,4,Blue,2,RGB,14,RGBA,15)] _ColorMask("Color Mask", Int) = 15
	}
	SubShader 
	{
		Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent"
        }
		
		Pass
		{
			Name "UnlitShader"
			ZWrite[_ZWrite]
			ZTest[_ZTest]
			Blend[_SrcBlend][_DstBlend]
			ColorMask [_ColorMask]
			Cull [_Cull]
			HLSLPROGRAM
#pragma prefer_hlslcc gles
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "../Includes/URPDefineSets.hlsl"


			struct appdata{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
			struct v2f {
				float4 position_CS : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};
			CBUFFER_START(UnityPerMaterial)
			DECLARE_TEXTURE_2D_ST(_MainTex)			
			float4 _Color;
			float _UseAlphaClip;
			CBUFFER_END
			v2f vert(appdata v)
			{
				v2f o;
				o.position_CS = TransformObjectToHClip(v.vertex.xyz);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
				half4 color = TEX_COLOR(_MainTex, i.texcoord);
				if(_UseAlphaClip > 0){
					clip(color.a * _Color.a - 0.01);
				}
				return color * _Color;
			}
			ENDHLSL
		}

	}
}
