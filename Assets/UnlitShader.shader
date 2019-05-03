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
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _MainTex_TexelSize;	

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv0.xy = v.uv.xy;
				o.uv1.xy = v.uv.xy + float2(_MainTex_TexelSize.x, 0);
				return o;
			}
			
			#define BIT_ENCODE_0 (1.0/255.0)
			#define BIT_ENCODE_3 (8.0/255.0)

			#define BIT_CHECK_0(X) (fmod(round(X*255), 2) >= 1)
			#define BIT_CHECK_3(X) (fmod(round(X*255), 16) >= 8)

			fixed4 frag (v2f i) : SV_Target
			{
				float texA0 = tex2D(_MainTex, i.uv0.xy).a;
				float texA1 = tex2D(_MainTex, i.uv1.xy).a;

				half f0 = min(1, 0.0 + BIT_CHECK_3(texA0) + BIT_CHECK_3(texA1));
				half f1 = BIT_CHECK_0(texA0);

				half encodedFlags = 0;
				encodedFlags += f0 * BIT_ENCODE_0;
				encodedFlags += f1 * BIT_ENCODE_3;

				return BIT_CHECK_0(encodedFlags);
			}
			ENDCG
		}
	}
}
