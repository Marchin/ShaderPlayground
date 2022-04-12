Shader "Unlit/VertexColorBlend" {
    SubShader {
        Tags { "RenderType"="Opaque" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct input {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float4 mvp : POSITION1;
            };

            v2f vert (input v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float4 wc = mul(unity_ObjectToWorld, v.vertex);
                o.mvp = float4(UnityObjectToWorldDir(wc), 1);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = i.mvp.y >= 0 ? fixed4(1, 1, 1, 1) : fixed4(0, 0, 0, 1);
                return col;
            }
            ENDCG
        }
    }
}