#version 430 core

layout(location = 0) in vec3 Vertex;
layout(location = 1) in vec2 TexCoord;

out vec2 fTexCoord;
out vec3 fWorldPos;

uniform mat4 Model;
uniform mat4 MVP;

void main()
{
	fTexCoord = TexCoord;
	fWorldPos = (Model * vec4(Vertex, 1.0)).xyz;
	gl_Position = MVP * vec4(Vertex, 1.0);
}