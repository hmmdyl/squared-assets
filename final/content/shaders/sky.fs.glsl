#version 430 core

in float fHeight;
in vec3 fWorldPos;

layout(location = 0) out vec4 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

uniform sampler2D ColourMap;
uniform float Time;

void main()
{
	//float texY = degrees(asin(fHeight)) / 90.0;
	float texY = fHeight;
	DiffuseOut.rgb = texture(ColourMap, vec2(Time, texY)).rgb;
	DiffuseOut.a = 1.0;
	NormalOut = vec3(0, 0, 0);
	WorldPositionOut = fWorldPos;
}