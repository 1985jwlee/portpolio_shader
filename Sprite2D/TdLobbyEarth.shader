Shader "_TimeDependers/TdLobbyEarth"
{
    Properties
    {
        [HideInInspector] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)
        [MaterialToggle] PixelSnap("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor("RendererColor", Color) = (1,1,1,1)
        [HideInInspector] _Flip("Flip", Vector) = (1,1,1,1)
        [HideInInspector][PerRendererData] _AlphaTex("External Alpha", 2D) = "white" {}
        [HideInInspector][PerRendererData] _EnableExternalAlpha("Enable External Alpha", Float) = 0
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        Cull Off
        Lighting Off
        Blend One One

        Pass
        {
            CGPROGRAM
            #pragma vertex SpriteVertZWriteOn
            #pragma fragment SpriteFragZWriteOn
            #pragma target 2.0
            #pragma multi_compile_instancing
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma multi_compile _ ETC1_EXTERNAL_ALPHA
            #include "UnitySprites.cginc"

            v2f SpriteVertZWriteOn(appdata_t IN)
            {
                v2f OUT;

                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                OUT.vertex = UnityFlipSprite(IN.vertex, _Flip);
                OUT.vertex = UnityObjectToClipPos(OUT.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color * _RendererColor;

                #ifdef PIXELSNAP_ON
                OUT.vertex = UnityPixelSnap(OUT.vertex);
                #endif

                return OUT;
            }

            float4 SpriteFragZWriteOn(v2f IN) : COLOR
            {
                fixed4 c = SampleSpriteTexture(IN.texcoord) * IN.color;

                clip(c.a - 0.01);
                return c * 4;
            }

        ENDCG
        }
    }
}
