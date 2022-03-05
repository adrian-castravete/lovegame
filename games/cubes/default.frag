varying vec4 worldPosition;
varying vec4 viewPosition;
varying vec4 screenPosition;
varying vec3 vertexNormal;
varying vec4 vertexColor;

uniform vec3 lightColor;
uniform vec3 lightPosition;
uniform vec3 diffuseColor;
uniform vec3 cameraPosition;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 pixCoord) {
	vec4 texColor = Texel(tex, texCoord);
	
	// get rid of transparent pixels
	if (texColor.a == 0.0) {
		discard;
	}
	
	float ambientStrength = 0.1;
	vec3 ambient = ambientStrength * lightColor;
	
	vec3 norm = normalize(vertexNormal);
	vec3 lightDir = normalize(lightPosition - worldPosition.xyz);
	
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = diff * lightColor;
	
	float specularStrength = 0.5;
	vec3 viewDir = normalize(cameraPosition - worldPosition.xyz);
	vec3 reflectDir = reflect(-lightDir, norm);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
	vec3 specular = specularStrength * spec * lightColor;
	
	vec3 result = texColor.rgb * diffuseColor * (diffuse + ambient + specular);
	
	return vec4(result, 1.0);
}