#version 430 core

layout(location = 0) in vec3 Vertex;
layout(location = 1) in vec3 Normal;

out vec3 fNormal;
out vec3 fWorldPos;

uniform mat4 ModelViewProjection;
uniform mat4 ModelView;
uniform mat4 Model;

uniform float Fit10bScale;

uniform float Time;
uniform float Amplitudes[8];
uniform float Wavelengths[8];
uniform float Speed[8];
uniform vec2 Direction[8];

float wave(vec2 coord, int i)
{
	float f = 2 * 3.14159 / Wavelengths[i];
	float phase = Speed[i] * f;
	float theta = dot(Direction[i], coord);
	return Amplitudes[i] * (sin(theta * f + Time * phase) / 2 + 0.5);
}

float waveHeight(vec2 coord)
{
	float h = 0;
	for(int i = 0; i < 8; i++)
		h += wave(coord, i);
	return h;
}

vec2 derivedWave(vec2 coord, int i)
{
	float freq = 2 * 3.14159 / Wavelengths[i];
	float phase = Speed[i] * freq;
	float theta = dot(Direction[i], coord);
	vec2 amp;
	amp.x = Amplitudes[i] * Direction[i].x * freq;
	amp.y = Amplitudes[i] * Direction[i].y * freq;
	float c = cos(theta * freq + Time * phase) / 2 + 0.5;
	vec2 norm;
	norm.x = -amp.x * c;
	norm.y = -amp.y * c;
	return norm;
}

vec3 waveNormal(vec2 coord)
{
	vec2 n;
	for(int i = 0; i < 8; i++)
		n += derivedWave(coord, i);
	vec3 n1 = vec3(-n.x, -n.y, -n.x);
	return normalize(n1);
}

void main()
{
	vec3 vertex = Vertex;
	vec3 normal = normalize((Normal / 1023.0) * 2.0 - 1.0);
	if(normal.y > 0.99)
	{
		vec4 waveVertex = Model * vec4(vertex, 1);
		vertex.y -= waveHeight(waveVertex.xz);
		normal.xyz += waveNormal(waveVertex.xz);
	}

	gl_Position = ModelViewProjection * vec4(vertex, 1);
	fNormal = normal;
	fWorldPos = (ModelView * vec4(Vertex, 1)).xyz;
}