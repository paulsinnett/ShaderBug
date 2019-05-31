Shader "Custom/RenderDepth" 
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {

		Pass
		{
		Tags { "RenderType"="Opaque" }
		
			ZWrite Off
			ZTest Always

			CGPROGRAM

			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

			uniform sampler2D _LastCameraDepthTexture;
				
			struct v2f 
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xyxy;
				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
				return Linear01Depth(SAMPLE_DEPTH_TEXTURE(_LastCameraDepthTexture, i.uv.xy));
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
