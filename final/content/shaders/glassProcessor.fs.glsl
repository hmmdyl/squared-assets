#version 430 core

in vec3 fWorldPos;
in vec3 fNormal;
in vec4 fColour;
in vec4 fClipSpace;

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

uniform sampler2D SceneDiffuse;

void main()
{
	vec2 ndc = fClipSpace.xy / fClipSpace.w;
	vec2 sceneTexCoord = clamp(ndc / 2.0 + 0.5, 0.0002, 0.9998);

	DiffuseOut = mix(texture(SceneDiffuse, sceneTexCoord).rgb, fColour.xyz, 0.5);
	NormalOut = fNormal;
	WorldPositionOut = fWorldPos;
}