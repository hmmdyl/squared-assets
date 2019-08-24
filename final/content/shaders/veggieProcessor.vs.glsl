#version 430 core

layout(location = 0) in vec4 Vertex;
layout(location = 1) in ivec4 Colour;
layout(location = 2) in ivec2 TexCoord;

out vec3 fWorldPos;
out vec2 fTexCoord;
flat out vec3 fColour;
flat out float fTexID;

uniform mat4 Model;
uniform mat4 ModelView;
uniform mat4 ModelViewProjection;

uniform float CompChunkMax;
uniform float CompFit10B;
uniform float CompOffset;

uniform float Time;
const float Amplitude = 0.25;
const float Wavelength = 1;
const float Speed = 1;
const vec2 Direction = vec2(1, 0);

float wave(vec2 coord)
{
	float f = 2 * 3.14159 / Wavelength;
	float phase = Speed * f;
	float theta = dot(Direction, coord);
	return Amplitude * (sin(theta * f + Time * phase) / 2 + 0.5);
}

void main() 
{
	vec3 vertex = (Vertex.xyz / CompFit10B) - CompOffset;

	gl_Position = ModelViewProjection * vec4(vertex, 1);
	fWorldPos = (Model * vec4(vertex, 1)).xyz;
	
	fTexCoord = vec2(0.5);
	fTexCoord = TexCoord / 65535.0;
	fColour = Colour.xyz / vec3(255);
	fTexID = Colour.w;// > 128 ? 1 : 0.5;
}