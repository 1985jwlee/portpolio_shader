Shader "URPTimeDefenders/UnitStealth"
{
    Properties
    {
        _StealthFresnelColor("", Color) = (1,1,1,1)
        _MainTex("", 2D) = "white"{}
        _StealthFresnelPower("", Float) = 10
        _AlphaTransit("", Range(0,1)) = 1
        _EmissiveMap("Emissive Texture", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderPipeline" = "UniversalRenderPipeline" }

        ZWrite Off
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha
        Stencil
		{
			Ref 0
			Comp Equal
			Pass IncrWrap
			ZFail Keep
		}

        Pass
        {
            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma vertex vert
            // This line defines the name of the fragment shader. 
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            
            #include "../Includes/URPDefineSets.hlsl"
            #include "../Includes/Functions.hlsl"
            CBUFFER_START(UnityPerMaterial)
            float4 _StealthFresnelColor;
            float _StealthFresnelPower;
            float _AlphaTransit;
            
            CBUFFER_END
            DECLARE_TEXTURE_2D(_MainTex)
            DECLARE_TEXTURE_2D(_EmissiveMap)

            struct Attributes
            {
                float4 positionOS   : POSITION;      
                float3 normalOS : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                float fresnel : TEXCOORD1;
            };            

            Varyings vert(Attributes i)
            {
                Varyings o;
                o.positionHCS = TransformObjectToHClip(i.positionOS.xyz);
                o.texcoord = i.texcoord;
                float3 normalWS = TransformObjectToWorldNormal(i.normalOS);
                float3 position_WS = TransformObjectToWorld(i.positionOS.xyz);
                float3 view_WS = WorldSpaceViewDir(position_WS);
                o.fresnel = pow(1 - saturate(dot(view_WS, normalWS)), _StealthFresnelPower);
                return o;
            }

            // The fragment shader definition.            
            half4 frag(Varyings i) : SV_Target
            {
                float4 c = TEX_COLOR(_MainTex, i.texcoord);
                c += TEX_COLOR(_EmissiveMap, i.texcoord);
                c.a = 1 - _AlphaTransit;
                c += float4(_StealthFresnelColor.rgb * i.fresnel, i.fresnel);
                return c;
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
