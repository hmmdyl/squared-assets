#version 430 core

in vec2 fTexCoord;
in vec3 fWorldPos;

layout(location = 0) out vec4 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

uniform sampler2D Texture;

void main()
{
	WorldPositionOut = fWorldPos;
	NormalOut = vec3(0);
	DiffuseOut = texture(Texture, fTexCoord);
}