#version 330
in vec2 inPosition;
out vec3 vertColor; 
out vec3 normal;
out vec3 lightVec;
out vec3 eyeVec;

uniform mat4 mat;

/* Blinn-Phong settings */
uniform float settingsLight;
uniform vec3 lightPos;
uniform vec3 eyePos;
uniform float ambient;

const float delta = 0.001;

vec3 computePosition(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;
    position.z = 0;
    return position;
}

void main() { 
        vec3 position;
        position = computePosition(inPosition);

        /* Compute normal */
        vec3 tempx = computePosition(inPosition + vec2(delta,0)) - computePosition(inPosition - vec2(delta,0));
	vec3 tempy = computePosition(inPosition + vec2(0,delta)) - computePosition(inPosition - vec2(0,delta));
	normal = normalize(cross(tempx,tempy));
        
        lightVec = normalize(lightPos - position);
	eyeVec = normalize(eyePos - position);

        vertColor = vec3(inPosition, 0.0);
        gl_Position = mat * vec4(position, 1.0); 
} 
