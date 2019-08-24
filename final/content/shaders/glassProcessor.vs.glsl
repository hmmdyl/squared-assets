#version 430 core

layout(location = 0) in vec4 Vertex;
layout(location = 1) in vec4 Normal;
layout(location = 2) in ivec4 Colour;

out vec3 fWorldPos;
out vec3 fNormal;
out vec4 fColour;
out vec4 fClipSpace;

uniform mat4 Model;
uniform mat4 ModelView;
uniform mat4 ModelViewProjection;

uniform float Fit10bScale;

void main()
{
	vec3 vertex = Vertex.xyz / Fit10bScale;
	fClipSpace = ModelViewProjection * vec4(vertex, 1);
	gl_Position = fClipSpace;
	fNormal = (Normal.xyz / 1023) * 2 - 1;
	fWorldPos = (Model * vec4(vertex, 1)).xyz;
	fColour = Colour / 255.0;
}