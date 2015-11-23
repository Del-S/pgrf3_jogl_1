#version 330
in vec2 inPosition;

out vec3 vertColor; 
out vec3 normal;
out vec3 lightDirection;
out vec3 viewDirection;
out vec2 vecPosition;
out float distance;
out vec3 position;

uniform int objectS;
uniform mat4 mat;

/* Texture settings */
uniform int textureS;
uniform sampler2D texture;
uniform sampler2D texture_n;
uniform sampler2D texture_h;

/* Blinn-Phong settings */
uniform int settingsLight;
uniform vec3 lightPos;
uniform vec3 eyePos;
uniform float ambient;
uniform int attenuationEn;
uniform vec3 attenuation;
uniform int reflectorEn;
uniform float spotCutOff; 
uniform vec3 spotDirection;

/* Mapping */
uniform int mapping;

const float delta = 0.01;
const float PI=3.1415926;

vec3 positionGrid(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;
    position.z = 0;
    return position;
}

vec3 positionCone(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;
        
    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * PI - ( PI / 2 );
    float t = zenith;

    position.x = t * cos(azimuth);
    position.y = t * sin(azimuth);
    position.z = t;

    return position;
}

vec3 positionTorus(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * 2.0 * PI;

    // * 1/3 - was too big (wanted to have all objects +/- same size
    position.x = cos(azimuth)+cos(zenith)*cos(azimuth) * 1/3;
    position.y = sin(azimuth)+cos(zenith)*sin(azimuth) * 1/3;
    position.z = sin(zenith) * 1/3;

    return position;
}

vec3 positionTrumpet(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * 2;
    float t = zenith;

    position.x = t;
    position.y = (1/(pow(t+1, 2)))*cos(azimuth);
    position.z = (1/(pow(t+1, 2)))*sin(azimuth);
    
    return position;
}

vec3 positionSphere(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * PI - ( PI / 2 );
    float r = cos(zenith);

    position.x = r * cos(azimuth);
    position.y = r * sin(azimuth);
    position.z = sin(zenith);

    return position;
}

vec3 positionElephantHead(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * PI ;
    float r = 3+cos(4*azimuth);

    // * 1/3 - was too big (wanted to have all objects +/- same size
    position.x = r * sin(zenith) * sin(azimuth) * 1/3;
    position.y = r * sin(zenith) * cos(azimuth) * 1/3;
    position.z = r * cos(zenith) * 1/3;

    return position;
}

vec3 positionSpaceStation(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 1.5 * PI + 1;  // +1 rotate to show for default camera settings
    float zenith = position.y * PI;
    float r = 1 + 0.5 * sin(4*zenith);

    position.x = r * sin(zenith) * sin(azimuth);
    position.y = r * sin(zenith) * cos(azimuth);
    position.z = r * cos(zenith);

    return position;
}

vec3 positionCylin(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * PI - ( PI / 2 );
    float r = 1;

    position.x = r * cos(azimuth);
    position.y = r * sin(azimuth);
    position.z = zenith;

    return position;
}

vec3 positionGoblet(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * 1.75 * PI - ( PI );
    float r = 1 + sin(zenith);

    // * 1/2 - was too big (wanted to have all objects +/- same size
    position.x = r * cos(azimuth) * 1/2;
    position.y = r * sin(azimuth) * 1/2;
    position.z = zenith * 1/2;

    return position;
}

vec3 positionJuicer(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * 2.0 * PI;
    float r = zenith;

    // * 1/3 - was too big (wanted to have all objects +/- same size
    position.x = r * sin(azimuth) * 1/3;
    position.y = r * cos(azimuth) * 1/3;
    position.z = cos(r) * 1/3;

    return position;
}

vec3 positionTent(vec2 inPosition) {
    vec3 position;
    position.xy = inPosition;

    float azimuth = position.x * 2.0 * PI;
    float zenith = position.y * 2.0 * PI;
    float r = ( 1 + max(sin(zenith),0)) * 0.5 * zenith;

    // * 1/2 - was too big (wanted to have all objects +/- same size
    position.x = r * sin(azimuth) * 1/2;
    position.y = r * cos(azimuth) * 1/2;
    position.z = (3 - zenith) * 1/2;

    return position;
}

vec3 generatePosition(vec2 inPosition) {
    vec3 position;

    switch (objectS) {
        // Not modified grid
        case 0:
            position = positionGrid(inPosition);
            break;
        // Parametric surfaces
        case 1:
            position = positionCone(inPosition);
            break;
        case 2:
            position = positionTorus(inPosition);
            break;                
        case 3:
            position = positionTrumpet(inPosition); 
            break;                     
        // Spherical objects
        case 4:
            position = positionSphere(inPosition); 
            break;
        case 5:
            position = positionElephantHead(inPosition); 
            break;
        case 6:
            position = positionSpaceStation(inPosition); 
            break;
        // Cylindrical objects
        case 7:
            position = positionCylin(inPosition); 
            break;
        case 8:
            position = positionGoblet(inPosition); 
            break;
        case 9:
            position = positionJuicer(inPosition); 
            break;
        case 10:
            position = positionTent(inPosition); 
            break;
        default:
            position = positionSphere(inPosition); 
            break;
    }

    return position;
}

mat3 computeTBN(vec2 inPos){
        vec3 dzdu = (generatePosition(inPosition + vec2(delta,0)) - generatePosition(inPosition - vec2(delta,0)))/2.0/delta;
	vec3 dzdv = (generatePosition(inPosition + vec2(0,delta)) - generatePosition(inPosition - vec2(0,delta)))/2.0/delta;
	
        vec3 tangent = normalize(dzdu);
	vec3 binormal = normalize(dzdv);
	vec3 normal = cross(tangent,binormal);
	binormal = cross(normal,tangent);
	return mat3(tangent,binormal,normal);
}

void main() { 
        vec3 position = generatePosition(inPosition);
        vecPosition = inPosition;
        gl_Position = mat * vec4(position, 1.0);
        vertColor = position;

        /* Compute normal */
        vec3 dzdu = (generatePosition(inPosition + vec2(delta,0)) - generatePosition(inPosition - vec2(delta,0)))/2.0/delta;
	vec3 dzdv = (generatePosition(inPosition + vec2(0,delta)) - generatePosition(inPosition - vec2(0,delta)))/2.0/delta;
        normal = normalize(cross(dzdu,dzdv));

        lightDirection = normalize(lightPos - position);
	viewDirection = normalize(eyePos - position);

        distance=length(lightDirection);
        
        mat3 TBN = computeTBN(vecPosition);
        
        vec2 texCoord = vecPosition;
        /* Change mapping (normal or paralax) */
        if (textureS == 1){
            if(mapping == 1){           
                /* Normal mapping */
                viewDirection = TBN * viewDirection;
                lightDirection = TBN * lightDirection;
            }
        }

        vec3 normal_comp = normal;
        if (textureS == 1){
            if(mapping == 1){           
                /* Normal mapping */
                vec3 bump = texture2D(texture_n, texCoord).rgb * 2.0 - 1.0;
                normal_comp = normalize(bump);
            } else if(mapping == 2) {
                /* Parallax mapping */		
                float height = texture2D(texture_h, texCoord).r;
                height = height * 0.04 - 0.02;
                texCoord = texCoord + (viewDirection.xy * height).yx;
                vec2 texUV = texCoord + viewDirection.xy * height;

                vec3 bump = texture2D(texture_n, texUV).rgb * 2.0 - 1.0;
                normal_comp = normalize(bump);
            }
        }

        if (settingsLight == 1) {
            vec3 halfVec = normalize(viewDirection + lightDirection);

            float diffusion = max(dot(normal_comp, lightDirection), 0.0);
            float specular = max(0, dot(normal_comp, halfVec));
            specular = pow(specular, 7); // shiningnes 7

            float att=1.0/(attenuation.x + attenuation.y*distance + attenuation.z*distance*distance); 
            
            if(attenuationEn == 0) {
                att = 1;
            }

            if (textureS == 1) {
		vertColor=vec3(1,1,1) * att * (min(ambient + diffusion,1)) + vec3(1,1,1) * specular;
            } else {
		vertColor=vec3(inPosition,0) * att * (min(ambient + diffusion,1)) + vec3(1,1,1) * specular;
            }

            if(reflectorEn == 1)  {
                float spotEffect = dot(normalize(spotDirection),normalize(-lightDirection));
                spotEffect = max(spotEffect,0);

                if (acos(spotEffect) <= radians(spotCutOff)) {
                    vertColor = vec3(0.0,0.0,0.0);
                }
            } 
        }
} 
