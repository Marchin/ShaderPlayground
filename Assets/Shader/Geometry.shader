Shader "Unlit/Geometry"
{
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _t ("T", Float) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2g {
                float4 vertex : SV_POSITION;
            };

            struct g2f {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float _t;
            float4 _Color;

            v2g vert(appdata i) {
                v2g o;
                o.vertex = i.vertex;
                return o;
            }

            [maxvertexcount(12)]
            void geom(triangle v2g input[3], inout TriangleStream<g2f> triStream) {
                float dist01 = distance(input[0].vertex, input[1].vertex);
                float dist02 = distance(input[0].vertex, input[2].vertex);
                float dist21 = distance(input[2].vertex, input[1].vertex);
                float4 hypotenuseMidpoint = 0;
                
                float4 a;
                float4 b;
                if (dist01 > dist02) {
                    if (dist01 > dist21) {
                        a = input[0].vertex;
                        b = input[1].vertex;
                    } else {
                        a = input[2].vertex;
                        b = input[1].vertex;
                    }
                } else {
                    if (dist02 > dist21) {
                        a = input[0].vertex;
                        b = input[2].vertex;
                    } else {
                        a = input[2].vertex;
                        b = input[1].vertex;
                    }
                }
                hypotenuseMidpoint = float4(((b.xyz - a.xyz)*0.5 + a.xyz), 1);
                // float4 center = float4((hypotenuseMidpoint.xyz - input[0].vertex.xyz)*0.5 + input[0].vertex.xyz, 1);

                float3 normal = normalize(cross(input[1].vertex.xyz - input[0].vertex.xyz, input[2].vertex.xyz - input[0].vertex.xyz));
                float4 newPoint = UnityObjectToClipPos(float4(hypotenuseMidpoint.xyz + _t * normal, 1));
                newPoint.w = 1;

                g2f o;

                float4 input0 = float4(UnityObjectToClipPos(input[0].vertex).xyz, 1);
                float4 input1 = float4(UnityObjectToClipPos(input[1].vertex).xyz, 1);
                float4 input2 = float4(UnityObjectToClipPos(input[2].vertex).xyz, 1);
    
                // TODO: investigate why this only work after normalizing the vectors for the cross product
                normal = normalize(cross(normalize(input0.xyz) - normalize(newPoint.xyz), normalize(input1.xyz) - normalize(newPoint.xyz)));
                o.vertex = input0;
                o.normal = normal;
                triStream.Append(o);
                o.vertex = input1;
                o.normal = normal;
                triStream.Append(o);
                o.vertex = newPoint;
                o.normal = normal;
                triStream.Append(o);
                triStream.RestartStrip();

                normal = normalize(cross(normalize(input1.xyz) - normalize(newPoint.xyz), normalize(input2.xyz) - normalize(newPoint.xyz)));
                o.vertex = input1;
                o.normal = normal;
                triStream.Append(o);
                o.vertex = input2;
                o.normal = normal;
                triStream.Append(o);
                o.vertex = newPoint;
                o.normal = normal;
                triStream.Append(o);
                triStream.RestartStrip();
                
                normal = normalize(cross(normalize(input2.xyz) - normalize(newPoint.xyz), normalize(input0.xyz) - normalize(newPoint.xyz)));
                o.vertex = input2;
                o.normal = normal;
                triStream.Append(o);
                o.vertex = input0;
                o.normal = normal;
                triStream.Append(o);
                o.vertex = newPoint;
                o.normal = normal;
                triStream.Append(o);
                triStream.RestartStrip();
            }

            fixed4 frag(g2f i) : SV_Target {
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float dotProd = max(dot(i.normal, lightDir), 0);
                dotProd = min(dotProd + 0.15, 1);
                fixed4 col = float4(dotProd.xxx * _LightColor0.rgb, 1) * _Color;
                
                return col;
            }
            ENDCG
        }
    }
}
