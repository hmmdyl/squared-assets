#version 430 core

in vec3 fNormal;
in vec3 fWorldPos;
in vec4 fClipSpacePre;
in vec4 fClipSpaceProper;
in vec3 fToCamera;
in vec3 fColour;

layout(location = 0) out vec4 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;
layout(location = 3) out vec2 MetaOut;

uniform sampler2D RefractionDiffuse;
uniform sampler2D RefractionNormal;
uniform sampler2D RefractionWorldPos;
uniform sampler2D RefractionDepth;
uniform sampler2D NormalMap;

uniform float NearPlane;
uniform float FarPlane;

uniform float FresnelReflectiveFactor;// = 0.9;
uniform float MurkDepth;
uniform float MinimumMurkStrength;
uniform float MaximumMurkStrength;

uniform float Time;

uniform vec3 DebugColour;

vec2 clipToTex(vec4 c)
{
	vec2 ndc = c.xy / c.w;
	vec2 t = ndc / 2.0 + 0.5;
	return clamp(t, 0.002, 0.998);
}

float fresnel(vec3 n)
{
	vec3 vv = normalize(fToCamera);
	float refractiveFactor = dot(vv, n);
	refractiveFactor = pow(refractiveFactor, FresnelReflectiveFactor);
	return clamp(refractiveFactor, 0.0, 1.0);
}

float linDepth(float z)
{
	return 2.0 * NearPlane * FarPlane / (FarPlane + NearPlane - (2.0 * z - 1.0) * (FarPlane - NearPlane));
}

float waterDepth(vec2 texCoord)
{
	float depth = texture(RefractionDepth, texCoord).r;
	float floored = linDepth(depth);
	float waterDist = linDepth(gl_FragCoord.z);
	return floored - waterDist;
}

vec3 murkiness(vec3 refractColour, vec3 waterColour, float waterDepth_)
{
	const float murkyDepth = 3;
	const float minCol = 0.3;
	const float maxCol = 1;
	float factor = smoothstep(0, MurkDepth, waterDepth_);
	float murkiness = MinimumMurkStrength + factor * (MaximumMurkStrength - MinimumMurkStrength);
	return mix(refractColour, waterColour, murkiness);
}

void main()
{
	vec3 waterColour = DebugColour;

	vec2 refractionTC = clipToTex(fClipSpacePre);

	float t = Time * 0.01;

	vec3 normalMap;
	if(fNormal.y > 0.9)
	{
		normalMap = texture(NormalMap, fWorldPos.xz / 2 + vec2(t, 0)).rgb; 
		normalMap.x = normalMap.x * 2 - 1;
		normalMap.z = normalMap.z * 2 - 1;
		normalMap = normalize(normalMap);
		normalMap = fNormal + normalMap * 0.5;
	}
	else normalMap = fNormal;

	vec3 refractionTexture = texture(RefractionDiffuse, refractionTC).rgb;
	vec3 refractionFinal = murkiness(refractionTexture, waterColour, waterDepth(refractionTC));

	vec3 colourFinal = refractionFinal;

	DiffuseOut = vec4(colourFinal, 1.0);
	WorldPositionOut = fWorldPos;
	NormalOut = normalMap;
	
	MetaOut.x = 120;
	MetaOut.y = 30;
}