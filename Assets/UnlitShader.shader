Shader "Test/UnlitShader"
{
	Properties
	{
		_CompareColour ("Compare Colour", Color) = (1.0, 0.5, 0.1, 1.0)
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
				fixed4 color : SV_Target;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed4 color : SV_Target;
			};

			uniform float4 _CompareColour;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float amplify_error = 500;
				return (i.color - _CompareColour) * amplify_error + i.color;
			}
			ENDCG
		}
	}
}
