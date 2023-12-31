Shader "Hatching/Unlit/TestShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "gray" {}
        _AnimationSpeed("Animation Speed", Range(0,3)) = 0
        _OffsetSize("Offset Size", Range(0,3)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100


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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;  
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _AnimationSpeed;
            float _OffsetSize;

            v2f vert (appdata v)
            {
                v2f o;

                v.vertex.z += sin(_Time.y * _AnimationSpeed + v.vertex.y * _OffsetSize) + sin(_Time.x * _AnimationSpeed + v.vertex.x * _OffsetSize);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv = v.uv; ????

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal,0.0),unity_ObjectToWorld).xyz);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
