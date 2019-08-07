#version 430 core

in vec3 fNormal;
in vec3 fWorldPos;
in vec4 fClipSpacePre;
in vec4 fClipSpaceProper;
in vec3 fToCamera;

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

uniform sampler2D RefractionDiffuse;
uniform sampler2D RefractionNormal;
uniform sampler2D RefractionWorldPos;
uniform sampler2D RefractionDepth;
uniform float NearPlane;
uniform float FarPlane;

const float FresnelReflectiveFactor = 1.5;

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
	float factor = smoothstep(0, murkyDepth, waterDepth_);
	float murkiness = minCol + factor * (maxCol - minCol);
	return mix(refractColour, waterColour, murkiness);
}

void main()
{
	//DiffuseOut = vec3(0.1, 0.75, 0.9);
	//DiffuseOut *= fNormal.y;
	vec2 refractionTexCoord = clipToTex(fClipSpaceProper);
	vec2 refractionPre = clipToTex(fClipSpacePre);

	float wd = waterDepth(refractionPre);
	vec3 refractionDiff = mix(texture(RefractionDiffuse, refractionPre).rgb, vec3(0.1, 0.75, 0.9), 0.5);

	DiffuseOut = refractionDiff;
	WorldPositionOut = fWorldPos;
	NormalOut = fNormal;
}