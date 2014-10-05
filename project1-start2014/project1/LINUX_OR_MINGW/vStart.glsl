#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec2 texCoord;
out vec3 fPos;
out vec3 fNormal;

uniform mat4 ModelView;
uniform mat4 Projection;
// ***My addition (Alex)***
uniform float sinAngle;

float xSpeed=0.2, zSpeed=xSpeed, h=5;

void main()
{
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vPosition).xyz;
  
    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
      
    // ***My addition (Alex)***
    if(sinAngle != 0) {
        vec4 waveP = gl_Position;
	waveP.y += h*sin(sinAngle + xSpeed*waveP.x) + h*sin(sinAngle + zSpeed*waveP.z);
	gl_Position.y = waveP.y;
    }
    
    // Pass values through for calculation in fragment shader
    fPos = pos;
    fNormal = vNormal;
}
