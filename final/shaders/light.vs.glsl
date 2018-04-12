#version 400 core

layout(location = 0) in vec3 Vertex;

uniform mat4 ModelViewProjection;

void main() {
	gl_Position = ModelViewProjection * vec4(Vertex, 1.0);
}