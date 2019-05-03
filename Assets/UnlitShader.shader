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

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _MainTex_TexelSize;	

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.uv.xy;
				return o;
			}
			
			#define BIT_ENCODE_3 (8.0/255.0)
			#define BIT_ENCODE_0 (1.0/255.0)

			#define BIT_CHECK_3(X) (fmod(round(X*255), 16) >= 8)

			fixed4 frag (v2f i) : SV_Target
			{
				float texA = tex2D(_MainTex, i.uv.xy).a;
				float texR = tex2D(_MainTex, i.uv.xy).r;

				float f0 = min(1, BIT_CHECK_3(texA) + BIT_CHECK_3(texR));
				float f1 = BIT_CHECK_3(texA);

				float encodedFlags = 0;
				encodedFlags += f0 * BIT_ENCODE_3;
				encodedFlags += f1 * BIT_ENCODE_0;

				return BIT_CHECK_3(encodedFlags);
			}
			ENDCG
		}
	}
}
