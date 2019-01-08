#version 400 core

layout(location = 0) in vec3 Vertex;

out vec3 fWorldPos;

uniform mat4 ModelViewProjection;
uniform mat4 Model;

void main() {
	gl_Position = ModelViewProjection * vec4(Vertex, 1);
	fWorldPos = (Model * vec4(Vertex, 1)).xyz;
}