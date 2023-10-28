Shader "Hatching/TestLitShader"
{
    Properties
    {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM

            // Pragmas and includes
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // structs
            struct vertexInput
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 tex : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };

            // user refined variables
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _MainTex_TexelSize;


            // Unity defined variables
            uniform float4 _LightColor0;

            // functions

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                
                //ucnauri modzraoba
               // v.pos.z += sin(_Time.y * 3 + v.pos.y * 3) + sin(_Time.x * 3 + v.pos.x * 3);
 
                o.pos = UnityObjectToClipPos(v.pos);
                o.normalDir = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz); 
                o.posWorld = mul(unity_ObjectToWorld, v.pos);

                o.tex = v.texcoord;
                return o;
            }

            float4 frag (vertexOutput i) : COLOR
            {
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float atten = 1.0; 

                float3 diffuseReflection = atten * _LightColor0.xyz  * max(0.0, dot(normalDirection, lightDirection));
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

                float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                
                float4 tex_hatch1 = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                float4 tex_hatch2 = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);

                //drawing
                if (i.tex.y%0.02<=0.005){
                    tex_hatch1.xyz = float3(0.0, 0.0, 0.0);
                }
                if ((i.tex.y+0.01)%0.02<=0.005){
                    tex_hatch2.xyz = float3(0.0, 0.0, 0.0);
                }

                if (lightFinal.x < 0.9){
                    tex.xyz *= tex_hatch1.xyz;
                }
                if (lightFinal.x < 0.6){
                    tex.xyz *= tex_hatch2.xyz;
                }
                if (lightFinal.x < 0.25){
                    tex.xyz *= float3(0,0,0);
                }

                return float4(tex.xyz, 1.0);
                //return float4(tex.xyz * lightFinal * _Color.xyz, 1.0);
            }
            ENDCG
        }
    }
}
