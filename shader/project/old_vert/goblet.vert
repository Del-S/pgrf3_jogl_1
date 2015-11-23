#version 330
in vec2 inPosition;
out vec3 vertColor; 
uniform mat4 mat;
const float PI=3.1415926;
void main() { 
        vec3 position;
        position.xy = inPosition;
        
        float azimuth = position.x * 2.0 * PI;
        float zenith = position.y * 1.75 * PI - ( PI );
        float r = 1 + sin(zenith);

        // * 1/2 - was too big (wanted to have all objects +/- same size
        position.x = r * sin(azimuth) * 1/2;
        position.y = r * cos(azimuth) * 1/2;
        position.z = zenith * 1/2;

	gl_Position = mat * vec4(position, 1.0); 
	vertColor = vec3(inPosition, 0);
}