Shader "Unlit/TextureScroll" {
    Properties {
        _MainTex0("Texture", 2D) = "white" {}
        _MainTex1 ("Texture", 2D) = "white" {}
        _Controller ("Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
            };

            struct v2f {
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex0;
            sampler2D _MainTex1;
            sampler2D _Controller;
            float4 _MainTex0_ST;
            float4 _MainTex1_ST;
            float4 _Controller_ST;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = TRANSFORM_TEX(o.vertex.xy, _MainTex0);
                o.uv1 = TRANSFORM_TEX(o.vertex.xy, _MainTex1);
                o.uv2 = TRANSFORM_TEX(o.vertex.xy, _Controller);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float4 tex0 = tex2D(_MainTex0, i.uv0);
                float4 tex1 = tex2D(_MainTex1, i.uv1);
                float4 controller = tex2D(_Controller, i.uv2);

                fixed4 col = lerp(tex0, tex1, controller);
                return col;
            }
            ENDCG
        }
    }
}
