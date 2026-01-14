#ifndef URP_DEFINE_SETS_INCLUDED
#define URP_DEFINE_SETS_INCLUDED

#define DECLARE_TEXTURE_2D(t) TEXTURE2D(t); SAMPLER(sampler##t);
#define DECLARE_TEXTURE_2D_ST(t) TEXTURE2D(t); SAMPLER(sampler##t); float4 t##_ST;
#define TEX_COLOR(t,u) SAMPLE_TEXTURE2D(t,sampler##t,u)

#endif