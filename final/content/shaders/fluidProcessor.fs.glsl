#version 430 core

in vec3 fNormal;
in vec3 fWorldPos;

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

void main()
{
	if(fNormal.y >= 0.5)
		DiffuseOut = vec3(0.1, 0.75, 0.9);
	else
		DiffuseOut = vec3(0.05, 0.35, 0.4);
	WorldPositionOut = fWorldPos;
	NormalOut = fNormal;
}