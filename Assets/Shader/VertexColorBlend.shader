Shader "Unlit/FragmentColorBlend" {
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
                float4 color : COLOR;
            };

            v2f vert (input v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float4 wc = mul(unity_ObjectToWorld, v.vertex);
                if (wc.y >= 0) {
                    o.color = float4(1, 1, 1, 1);
                } else {
                    o.color = float4(0, 0, 0, 1);
                }
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = i.color;
                return col;
            }
            ENDCG
        }
    }
}

