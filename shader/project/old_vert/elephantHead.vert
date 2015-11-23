#version 330
in vec2 inPosition;
out vec3 vertColor; 
uniform mat4 mat;
const float PI=3.1415926;
void main() { 
        vec3 position;
        position.xy = inPosition;
        
        float azimuth = position.x * 2.0 * PI;
        float zenith = position.y * PI ;
        float r = 3+cos(4*azimuth);

        // * 1/3 - was too big (wanted to have all objects +/- same size
        position.x = r * sin(zenith) * cos(azimuth) * 1/3;
        position.y = r * sin(zenith) * sin(azimuth) * 1/3;
        position.z = r * cos(zenith) * 1/3;

	gl_Position = mat * vec4(position, 1.0); 
	vertColor = vec3(inPosition, 0);
}