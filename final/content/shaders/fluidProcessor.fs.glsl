#version 430 core

in vec3 fNormal;
in vec3 fWorldPos;

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

void main()
{
	DiffuseOut = vec3(0.1, 0.75, 0.9);
	//DiffuseOut *= fNormal.y;
	WorldPositionOut = fWorldPos;
	NormalOut = fNormal;
}