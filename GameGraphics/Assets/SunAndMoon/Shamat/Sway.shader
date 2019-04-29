Shader "Custom/Sway"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_WorldSize("World Size", vector) = (3,3,3,1)
		_WindSpeed("Wind Speed", vector) = (1, 1, 1, 1)
		_WindTex("Wind Texture", 2D) = "white" {}
		_WaveSpeed("Wave Speed", float) = 1.0
		_WaveAmp("Wave Amp", float) = 1.0


	}
	SubShader
	{
		Pass
		{
			Tags
			{
				"DisableBatching" = "True"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase // shadows
			#pragma glsl
			#include "UnityCG.cginc"

			sampler2D _MainTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD3;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD3;
				float4 vertex : SV_POSITION;
				float3 vertexInWorldCoords : TEXCOORD0;
				float3 normalInWorldCoords : NORMAL;
				float2 sp : TEXCOORD1;
			};

			float4 _WorldSize;
			float4 _Color;
			float4 _WindSpeed;
			float4 _WaveSpeed;
			float4 _WaveAmp;
			sampler2D _WindTex;
			

			v2f vert(appdata v)
			{
				v2f o;

				o.uv = v.uv;

				// Vertex position in WORLD coords
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); 
				// Normal in WORLD coords
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); 
				// o.vertex = UnityObjectToClipPos(v.vertex);

				float2 samplePos = o.vertexInWorldCoords.xz / _WorldSize.xz;
				samplePos += _Time.y * _WindSpeed.xz;
				o.sp = samplePos;
				// apply wave animation

				float windSample = tex2Dlod(_WindTex, float4(samplePos.xy, 0, 0));
				float newz = v.vertex.z + sin(_WaveSpeed*windSample)*_WaveAmp;
				float newx = v.vertex.x + cos(_WaveSpeed*windSample)*_WaveAmp;
				float newy = v.vertex.y;

				float4 xyz = float4(newx, newy, newz, 1.0);

				o.vertex = UnityObjectToClipPos(xyz);			

				return o;
			}

			
			

			float4 frag(v2f i) : COLOR
			{
				return float4(0, frac(i.sp.x + 0.5), 0, 1);
				//return float4(frac(i.vertexInWorldCoords.z), 0, 0, 1);
			}

			
			ENDCG
		}
	}
    FallBack "Diffuse"
}
