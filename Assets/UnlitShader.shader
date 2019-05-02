Shader "Test/UnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma debug
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

#define BIT_ENCODE_0 (1.0/255.0)
#define BIT_ENCODE_1 (2.0/255.0)
#define BIT_ENCODE_2 (4.0/255.0)
#define BIT_ENCODE_3 (8.0/255.0)
#define BIT_ENCODE_4 (16.0/255.0)
#define BIT_ENCODE_5 (32.0/255.0)

#define BIT_CHECK_1(X) (fmod(round(X*255), 4) >= 2)
#define BIT_CHECK_2(X) (fmod(round(X*255), 8) >= 4)
#define BIT_CHECK_3(X) (fmod(round(X*255), 16) >= 8)
#define BIT_CHECK_4(X) (fmod(round(X*255), 32) >= 16)
#define BIT_CHECK_5(X) (fmod(round(X*255), 64) >= 32)
#define BIT_CHECK_6(X) (fmod(round(X*255), 128) >= 64)

half decodeFlags(float encodedFlags)
{
	half f2 = BIT_CHECK_2(encodedFlags);
	half f3 = 0;
	half f4 = 0;
	half f5 = BIT_CHECK_5(encodedFlags);
	half f6 = BIT_CHECK_6(encodedFlags);
	return f2;
}

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uv[2] : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform float4 _MainTex_TexelSize;	

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float2 uv = v.uv.xy;
				o.uv[0].xy = uv;
				o.uv[0].zw = uv + float2(_MainTex_TexelSize.x, 0);
				o.uv[1].xy = uv + float2(_MainTex_TexelSize.x, 0);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float texA = tex2D(_MainTex, i.uv[0].xy).a;
				float texA2 = tex2D(_MainTex, i.uv[1].xy).a;

				half f6 = 0;
				half f5 = 0;
				half f4 = 0;
				half f3 = 0;//BIT_CHECK_4(texA);
				half f1 = 0;
				half f2 = min(1, BIT_CHECK_3(texA) + BIT_CHECK_3(texA2));

				float encodedFlags = 0;
				encodedFlags += f3 * BIT_ENCODE_1;
				encodedFlags += f2 * BIT_ENCODE_2;
				encodedFlags += f3 * BIT_ENCODE_3;
				encodedFlags += f3 * BIT_ENCODE_4;
				encodedFlags += f3 * BIT_ENCODE_5;
				encodedFlags += 0;

				half d1 = BIT_CHECK_1(encodedFlags);
				decodeFlags(encodedFlags);

				return BIT_CHECK_2(encodedFlags);
			}
			ENDCG
		}
	}
}
