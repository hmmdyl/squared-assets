#version 400 core

in vec3 fWorldPos;

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

void main() {
	DiffuseOut = vec3(0, 0.9, 0.1);
	WorldPositionOut = fWorldPos;
	NormalOut = vec3(0, 1, 0);
}