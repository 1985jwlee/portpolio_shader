#ifndef UNIT_VARIABLE_INCLUDED
#define UNIT_VARIABLE_INCLUDED

#include "URPDefineSets.hlsl"

#ifndef REDEFINE_BODYSHADER_VARIABLE

#ifdef UNIT_BODY_SHADER
CBUFFER_START(UnityPerMaterial)
DECLARE_TEXTURE_2D_ST(_MainTex)
DECLARE_TEXTURE_2D_ST(_EmissiveMap)
float _NeedRimLight;
DECLARE_TEXTURE_2D_ST(_RimMap);
float4 _RimColor;
float _IsFace;
float4 _FacialUV;
float _FacialRate;
DECLARE_TEXTURE_2D(_AmbientTexture)
float4 _TilingSpeed;
float4 _AmbientUV;
float _GrayScaleLerp; float _BodyColorLerp;
float4 _PreMulBodyColor; float _PreMulBodyValue;
float4 _AddBodyColor; float4 _BodyColor; float4 _OneToneColor;
DECLARE_TEXTURE_2D(_CutsceneAmbientTexture)
DECLARE_TEXTURE_2D(_AmbientRamp)
float _ModelHeight;
float _ShadowOffsetBody;

float _UseLightMapper;
float4 _DirectionLightV0;
float4 _DirectionLightV1;
float4 _DirectionLightV2;
float4 _DirectionLightV3;
float4 _PointLight0_V0;
float4 _PointLight0_V1;
float4 _PointLight0_V2;
float4 _PointLight0_V3;
float4 _PointLight1_V0;
float4 _PointLight1_V1;
float4 _PointLight1_V2;
float4 _PointLight1_V3;
float4 _PointLight2_V0;
float4 _PointLight2_V1;
float4 _PointLight2_V2;
float4 _PointLight2_V3;
float4 _PointLight3_V0;
float4 _PointLight3_V1;
float4 _PointLight3_V2;
float4 _PointLight3_V3;

DECLARE_TEXTURE_2D(_MaskTexture)
DECLARE_TEXTURE_2D(_NormalTexture)
float _ShadowBrightness;
float _CelMidPoint;
float _CelSoftness;
float4 _IndirectColor;
float _IndirectMulti;        
TEXTURECUBE(_MatCap); SAMPLER(sampler_MatCap);
float4 _MatCapColor;
float _MatCapPow;
float4 _EmitColor;
float _EmitIntensity;
float _RimPower;
float _IsHair;
TEXTURECUBE(_HairRingCube); SAMPLER(sampler_HairRingCube);
float4 _HairRingColor;
float _HairRingPow;            
float _ShadePivot;
float _RelativeScale;
CBUFFER_END
#endif

#ifdef UNIT_SHADOW_SHADER
CBUFFER_START(UnityPerMaterial)     
float _ShadowClip;
float4 _ShadowColor;
float _ShadowOffset;
float4 _LightDirection;
CBUFFER_END
#endif

#ifdef UNIT_OUTLINE_SHADER
CBUFFER_START(UnityPerMaterial)
DECLARE_TEXTURE_2D_ST(_OutlineTex)
half _OutlineWidth;
float _HideOutline;
half _IsFace;
half4 _OutlineColor;
float _OutlineLerp;  
float _OutlineMultiply;
float _ClipAll;
CBUFFER_END
#endif

#endif

struct appdata {
    float4 vertex : POSITION;
#if defined(UNIT_BODY_SHADER)
    float3 normal : NORMAL;
    float2 texcoord : TEXCOORD0;
#elif defined(UNIT_OUTLINE_SHADER)
    float3 normal : NORMAL;
    float2 texcoord : TEXCOORD0;
    float4 color : COLOR;
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


#ifndef CUSTOM_VERT_STRUCT
struct v2f {
    float4 position_CS : SV_POSITION;
#ifdef UNIT_OUTLINE_SHADER
    float2 texcoord : TEXCOORD0;
    float4 color : TEXCOORD1;
#endif    
#ifdef UNIT_BODY_SHADER
    float2 texcoord : TEXCOORD0;
    float3 normal_OS : NORMAL;    
    float3 normal_WS : TEXCOORD1;
    float3 position_WS : TEXCOORD2;
    float3 view_WS : TEXCOORD3;
    float4 texcoord_SS : TEXCOORD4;
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
#endif

#endif

