#version 150

in  vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
in  vec3 fPos;
in  vec3 fNormal;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform vec4 LightPosition;
uniform float Shininess;

out vec4 fColor;

uniform sampler2D texture;

void
main()
{
    
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - fPos;
    float Ldist = length(Lvec);

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -fPos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(fNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct/pow(Ldist, 0.75);

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct/pow(Ldist, 0.75);

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct/pow(Ldist, 0.75);
    
    if( dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    fColor.rgb = globalAmbient  + ambient + diffuse + specular;
    fColor.a = 1.0;
    
    fColor = fColor * texture2D( texture, texCoord * 2.0 );
}
