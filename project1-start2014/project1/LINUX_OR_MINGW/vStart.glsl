#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec2 texCoord;
out vec3 fPos;
out vec3 fNormal;

uniform mat4 ModelView;

void main()
{
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vPosition).xyz;
    
    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
    
    // Pass values through for calculation in fragment shader
    fPos = pos;
    fNormal = vNormal;
}
