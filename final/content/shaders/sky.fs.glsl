#version 430 core

in float fHeight;
in vec3 fWorldPos;

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

uniform sampler2D ColourMap;

void main()
{
	DiffuseOut = texture(ColourMap, vec2(0.5, fHeight)).rgb;
	NormalOut = vec3(0, 0, 0);
	WorldPositionOut = fWorldPos;
}