#version 330
in vec2 inPosition;
out vec3 vertColor; 
uniform mat4 mat;
const float PI=3.1415926;
void main() { 
        vec3 position;
        position.xy = inPosition;
        
        float azimuth = position.x * 2.0 * PI;
        float zenith = position.y * PI - ( PI / 2 );
        float t = zenith;

        position.x = t * cos(azimuth);
        position.y = t * sin(azimuth);
        position.z = t;

	gl_Position = mat * vec4(position, 1.0); 
	vertColor = vec3(inPosition, 0);
}