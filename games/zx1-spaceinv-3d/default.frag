varying vec4 worldPosition;
varying vec4 viewPosition;
varying vec4 screenPosition;
varying vec3 vertexNormal;
varying vec4 vertexColor;

uniform vec3 cameraPosition;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 pixCoord) {
	float ambientStrength = 0.1;
  float specularStrength = 0.5;

	vec4 texColor = Texel(tex, texCoord);
	
	// get rid of transparent pixels
	if (texColor.a == 0.0) {
		discard;
	}
	
	float alpha = texColor.a;

  vec3 lightDir = normalize(vec3(-1, 1, 1));
	vec3 normal = normalize(vertexNormal);
  float diffuse = max(0.0, dot(lightDir, normalize(vertexNormal)));

  vec3 viewDir = normalize(cameraPosition - worldPosition.xyz);
  vec3 reflectDir = reflect(-lightDir, normal);
  float specular = specularStrength * pow(max(dot(viewDir, reflectDir), 0.0), 8.0);
	
	vec3 result = texColor.rgb * min(ambientStrength + diffuse + specular, 1.0);
	
	return vec4(result, alpha);
}
