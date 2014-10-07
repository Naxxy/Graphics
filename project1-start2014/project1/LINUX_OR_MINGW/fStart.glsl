#version 150

in  vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
in  vec3 fPos;
in  vec3 fNormal;

uniform vec3 AmbientProduct1, DiffuseProduct1, SpecularProduct1, AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform mat4 ModelView;
uniform vec4 Light1Position, Light2Position;
uniform float Shininess;

out vec4 fColor;

uniform sampler2D texture;

void
main()
{
    
    // The vector to the light from the vertex    
    vec3 Lvec1 = Light1Position.xyz - fPos;
    float Ldist1 = length(Lvec1);

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L1 = normalize( Lvec1 );   // Direction to the light source
    vec3 E1 = normalize( -fPos );   // Direction to the eye/camera
    vec3 H1 = normalize( L1 + E1 );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N1 = normalize( (ModelView*vec4(fNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient1 = AmbientProduct1/pow(Ldist1, 0.75);

    float Kd1 = max( dot(L1, N1), 0.0 );
    vec3  diffuse1 = Kd1*DiffuseProduct1/pow(Ldist1, 0.75);

    float Ks1 = pow( max(dot(N1, H1), 0.0), Shininess);
    vec3  specular1 = Ks1 * SpecularProduct1/pow(Ldist1, 0.75);
    
    if( dot(L1, N1) < 0.0 ) {
	specular1 = vec3(0.0, 0.0, 0.0);
    } 
	
	
    // calculations for second, directional light, referenced http://en.wikibooks.org/wiki/GLSL_Programming/GLUT/Multiple_Lights   
    vec3 L2 = normalize( Light2Position.xyz ); // since this light is directional, light direction is the vector given by light coordinates
    
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 E2 = normalize( -fPos );   // Direction to the eye/camera
    vec3 H2 = normalize( L2 + E2 );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N2 = normalize( (ModelView*vec4(fNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient2 = AmbientProduct2;

    float Kd2 = max( dot(L2, N2), 0.0 );
    vec3  diffuse2 = Kd2*DiffuseProduct2;

    float Ks2 = pow( max(dot(N2, H2), 0.0), Shininess);
    vec3  specular2 = Ks2 * SpecularProduct2;
    
    if( dot(L2, N2) < 0.0 ) {
	specular2 = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    fColor.rgb = globalAmbient  + ambient1 + diffuse1 + specular1 + ambient2 + diffuse2 + specular2;
    fColor.a = 1.0;
    
    fColor = fColor * texture2D( texture, texCoord * 2.0 );
}
