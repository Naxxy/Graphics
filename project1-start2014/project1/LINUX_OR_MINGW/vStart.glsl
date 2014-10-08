#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec2 texCoord;
out vec3 fPos;
out vec3 fNormal;

uniform mat4 ModelView;t
uniform mat4 Projection;

// ***My addition (Alex)***
uniform float sinAngle;
uniform bool ground;

float xSpeed=0.2, zSpeed=0.5, h=5;
// ***End of my addition (Alex)***


void main()
{
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vPosition).xyz;
  
    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
      
    // ***My addition (Alex)***
    if(sinAngle != 0 && ground) {
        vec4 waveP = gl_Position;
	waveP.y += h*sin(sinAngle + xSpeed*waveP.x) + h*sin(sinAngle + zSpeed*waveP.z);
	gl_Position.y = waveP.y;
    }
    // ***End of my addition (Alex)***
    
    // Pass values through for calculation in fragment shader
    fPos = pos;
    fNormal = vNormal;
}
