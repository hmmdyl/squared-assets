#version 400 core

uniform bool isShadowDepth;

in vec3 fVertex;
in vec3 fWorldPos;
in vec3 fNormal;
in vec3 fTexCoord;
in vec3 fTangent;

layout(location = 0) out vec4 DiffuseOut;
layout(location = 1) out vec3 WorldPosOut;
layout(location = 2) out vec3 NormalOut;

uniform bool isDiffuseTexture;
uniform bool isNormalTexture;

uniform vec4 diffuseColour;
uniform sampler2D diffuseTexture;
uniform sampler2D normalTexture;

uniform bool useParallaxMapping;
uniform sampler2D displacementMapTexture;
uniform float heightScale;

uniform float transparency;
uniform float pixelDiscard;

uniform vec3 viewPosition;

vec3 calculateBumpedNormal(mat3 tbn) {	
	vec3 bmn = texture(normalTexture, fTexCoord).xyz;
	vec3 nn = tbn * bmn;
	nn = normalize(nn);
	return nn;
}

vec2 parallaxMapping(vec2 texc, vec3 view) {
	float height = texture(displacementMapTexture, texc).r;
	return texc - view.xy * (height * heightScale);
}

void main() {
	vec4 diffuse = vec4(0, 0, 0, 0);
	vec3 normal = vec3(0, 0, 0);

	vec2 texCoord = fTexCoord;
	
	if((useParallaxMapping && !isDiffuseTexture) || (isNormalTexture && !isShadowDepth)) {
		vec3 n = normalize(fNormal);
		vec3 t = normalize(fTangent);
		t = normalize(t - dot(t, n) * n);
		vec3 b = cross(t, n);
		mat3 tbn = mat3(t, b, n);

		if(isNormalTexture && !isShadowDepth)
			normal = calculateBumpedNormal(tbn);
		else
			normal = fNormal;
			
		if(useParallaxMapping) {
			vec3 tangWorldPos = tbn * fWorldPos;
			vec3 tangViewPos = tbn * viewPosition;
			vec3 viewDir = normalize(tangViewPos - tangWorldPos);
			texCoord = parallaxMapping(fTexCoord, viewDir);
			if(texCoord.x > 1.0 || texCoord.y > 1.0 || texCoord.x < 0.0 || texCoord.y < 0.0)
				discard;
		}			
	}
	
	if(isDiffuseTexture)
		diffuse = texture(diffuseTexture, texCoord);
	else
		diffuse = diffuseColour;
		
	diffuse.a *= transparency;
	
	if(diffuse.a < pixelDiscard)
		discard;
		
	DiffuseOut = diffuse;
	NormalOut = normal;
	WorldPosOut = fWorldPos;
}