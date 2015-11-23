#version 330
in vec3 vertColor; // vstup z predchozi casti retezce
in vec3 normal;
in vec3 lightDirection;
in vec3 viewDirection;
in vec2 vecPosition;
in float distance;

out vec4 outColor;

/* Texture settings */
uniform int textureS;
uniform sampler2D texture;
uniform sampler2D texture_n;
uniform sampler2D texture_h;

/* Blinn-Phong settings */
uniform int settingsLight;
uniform float ambient;
uniform vec3 attenuation;

/* Mapping */
uniform int mapping;

void main() {    
        vec3 normal_comp = normal;
        vec2 texCoord = vecPosition;

        /* Change mapping (normal or paralax) */
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
            }
        }
        
        /* Light switching */
        if(settingsLight == 0) {

            /* No light */
            if (textureS == 1){
                vec3 vertColorT = vec3(1,1,1);
                outColor = vec4(texture2D(texture, texCoord).rgb * vertColorT, 1.0);
            } else {
                outColor = vec4(vecPosition, 0.0, 1.0);
            }

        } else if(settingsLight == 1) {

            /* Light per vertex */
            if (textureS == 1){
                outColor = vec4(texture2D(texture, texCoord).rgb * vertColor, 1.0);
            } else {
                outColor = vec4(vertColor, 1.0);
            }

        } else if(settingsLight == 2) {

            /* Light per pixel */
            vec3 halfVec = normalize(viewDirection + lightDirection);

            float diffusion = max(dot(normal_comp, lightDirection), 0.0);
            float specular = max(0, dot(normal_comp, halfVec));
            specular = pow(specular, 7); // shiningnes 7

            vec3 tempColor; 
            if (textureS == 1) {
		tempColor = texture2D(texture, texCoord).rgb;
            } else {
		tempColor = vec3(texCoord, 0);
            }
		
            // Attenuation
            float att=1.0/(attenuation.x + attenuation.y*distance + attenuation.z*distance*distance); 

            vec3 fragmentColor = tempColor * att * (min(ambient + diffusion,1)) + vec3(1,1,1) * specular;
            outColor=vec4(fragmentColor,1.0);

        } else {

            /* Default testing colors */
            outColor = vec4(vertColor, 1.0); 
        }
} 
