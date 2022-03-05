varying vec4 worldPosition;
varying vec4 viewPosition;
varying vec4 screenPosition;
varying vec3 vertexNormal;
varying vec4 vertexColor;
varying float lightIntensity;

uniform float ti;

float waves(vec2 xy, float t) {
	return 0.5 + 0.5 * sin(0.1 * xy.y - 10.0 * t + sin(0.1 * xy.x + 4.0 * t));
}

vec3 lerpv3(vec3 a, vec3 b, float r) {
	return a + (b-a) * r;
}

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 pixCoord) {
	vec4 texColor = Texel(tex, texCoord);
	
	// get rid of transparent pixels
	if (texColor.a == 0.0) {
		discard;
	}
	
	vec3 normal = normalize(vertexNormal);
	float alpha = texColor.a;
	
	vec3 result = lerpv3(texColor.rgb, vec3(1.0, 1.0, 1.0), waves(pixCoord, ti));
	
	return vec4(result, alpha);
}