uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;
uniform bool isCanvasEnabled;

attribute vec3 VertexNormal;

varying vec4 worldPosition;
varying vec4 viewPosition;
varying vec4 screenPosition;
varying vec3 vertexNormal;
varying vec4 vertexColor;

vec4 position(mat4 transformProjection, vec4 vertexPosition) {
	worldPosition = modelMatrix * vertexPosition;
	viewPosition = viewMatrix * worldPosition;
	screenPosition = projectionMatrix * viewPosition;
	
	vertexNormal = mat3(modelMatrix) * VertexNormal;
	vertexColor = VertexColor;
	
	if (isCanvasEnabled) {
		screenPosition.y *= -1.0;
	}

	return screenPosition;
}
