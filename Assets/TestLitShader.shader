Shader "Hatching/TestLitShader"
{
    Properties
    {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
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
            };

            struct vertexOutput
            {
                float4 col : COLOR;
                float4 pos : SV_POSITION;
            };

            // user refined variables
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            // Unity defined variables
            uniform float4 _LightColor0;

            // functions
            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                
                //ucnauri modzraoba
                //v.pos.z += sin(_Time.y * 5 + v.pos.y * 2) + sin(_Time.x * 5 + v.pos.x * 2);


                //ganateba
                float3 normalDirection = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz); 
                float3 lightDirection;
                float atten = 1.0; 

                lightDirection = normalize(_WorldSpaceLightPos0.xyz);

                float3 diffuseReflection = atten * _LightColor0.xyz  * max(0.0, dot(normalDirection, lightDirection));
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

                o.col = float4(lightFinal * _Color.rgb, 1.0);
                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            float4 frag (vertexOutput i) : SV_Target
            {
                // sample the texture
                float4 col = i.col;
                return col;
            }
            ENDCG
        }
    }
}
