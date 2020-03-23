Shader "Hidden/FlipbookImage"
{
    Properties
    {
        _MainTex ("MainTexture", 2D) = "white" {}
		_Frame("Frame", Float) = 0
		_Columns("Columns", int) = 256
		_Rows("Rows", int) = 256
		_TextureSize("TextureSize", Float) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		Tags { "Queue" = "Transparent" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 color : COLOR;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				o.color = v.color;
                return o;
            }

            sampler2D _MainTex;
			float4 _MainTex_TexelSize;		
			float _Frame;
			int _Columns, _Rows;
			float _TextureSize;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 unit = float2(1 / (float)_Columns, 1 / (float)_Rows);

				float2 base;
				float frame = floor(_Frame % (_Columns * _Rows));
				base.x = frame % (float)_Columns / (float)_Columns;
				base.y = 1-(floor(frame / (float)_Columns) / (float)_Rows + unit.y);
			
				fixed4 col = tex2D(_MainTex, base + (i.uv * unit * _TextureSize) + unit * (1-_TextureSize) / 2);
                return col * i.color;
            }
            ENDCG
        }
    }
}
