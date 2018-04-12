#version 400 core

layout(location = 0) out vec3 DiffuseOut;
layout(location = 1) out vec3 WorldPositionOut;
layout(location = 2) out vec3 NormalOut;

uniform vec3 LightPosition;
uniform vec3 LightColour;
uniform float AmbientIntensity;
uniform float DiffuseIntensity;
uniform float ConstantAttenuation;
uniform float LinearAttenuation;
uniform float ExponentialAttenuation;

uniform vec2 FramebufferSize;

uniform sampler2D WorldPosTexture;
uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;
uniform sampler2D DepthTexture;

uniform vec3 CameraPosition;

vec4 calculateLight(vec3 colour, float ambientIntensity, float diffuseIntensity, vec3 lightDirection, vec3 worldPosition, vec3 normal) {
	vec4 ambientColour = vec4(colour * ambientIntensity, 1.0);
	float diffuseFactor = dot(normal, -lightDirection);
	
	vec4 diffuseColour = vec4(0.0);
	vec4 specularColour = vec4(0.0);
	
	if(diffuseFactor > 0.0) {
		diffuseColour = vec4(colour * diffuseIntensity * diffuseFactor, 1.0);
		
		vec3 vertToEye = normalize(CameraPosition - worldPosition);
		vec3 lightReflect = normalize(reflect(lightDirection, normal));
		float specularFactor = dot(vertToEye, lightReflect);
		
		if(specularFactor > 0.0) {
			specularFactor = pow(specularFactor, 0.1); // todo: implement specular mapping
			specularColour = vec4(colour * 0.01 * specularFactor, 1.0);
		}
	}
	
	return (ambientColour + diffuseColour + specularColour);
}

vec4 calculatePointLight(vec3 worldPosition, vec3 normal) {
	vec3 lightDir = worldPosition - LightPosition;
	float distance = length(lightDir);
	lightDir = normalize(lightDir);
	
	vec4 colour = calculateLight(LightColour, AmbientIntensity, DiffuseIntensity, lightDir, worldPosition, normal);
	
	float attenuation = ConstantAttenuation + LinearAttenuation * distance + ExponentialAttenuation * distance * distance;
	attenuation = max(1.0, attenuation);
	
	return colour / attenuation;
}

vec2 calculateTexCoord() {
	return gl_FragCoord.xy / FramebufferSize;
}

void main() {
	vec2 texCoord = calculateTexCoord();
	vec3 worldPos = texture(WorldPosTexture, texCoord).rgb;
	WorldPositionOut = worldPos;
	vec3 diffuse = texture(DiffuseTexture, texCoord).rgb;
	vec3 normal = normalize(texture(NormalTexture, texCoord).rgb);
	NormalOut = normal;
	
	DiffuseOut = (vec4(diffuse, 1) * calculatePointLight(worldPos, normal)).xyz;
}
