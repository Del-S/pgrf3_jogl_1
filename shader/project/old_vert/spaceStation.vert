#version 330
in vec2 inPosition;
out vec3 vertColor; 
uniform mat4 mat;
const float PI=3.1415926;
void main() { 
        vec3 position;
        position.xy = inPosition;
        
        float azimuth = position.x * 1.5 * PI + 1;  // +1 rotate to show for default camera settings
        float zenith = position.y * PI;
        float r = 1 + 0.5 * sin(4*zenith);

        position.x = r * sin(zenith) * cos(azimuth);
        position.y = r * sin(zenith) * sin(azimuth);
        position.z = r * cos(zenith);

	gl_Position = mat * vec4(position, 1.0); 
	vertColor = vec3(inPosition, 0);
}