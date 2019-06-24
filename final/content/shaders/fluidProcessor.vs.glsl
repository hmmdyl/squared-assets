#version 430 core

layout(location = 0) in vec3 Vertex;
layout(location = 1) in vec3 Normal;

out vec3 fNormal;
out vec3 fWorldPos;

uniform mat4 ModelViewProjection;
uniform mat4 ModelView;

uniform float Fit10bScale;

void main()
{
	gl_Position = ModelViewProjection * vec4(Vertex, 1);
	fNormal = (Normal / 1023) * 2 - 1;
	fNormal = normalize(fNormal);
	fWorldPos = (ModelView * vec4(Vertex, 1)).xyz;
}