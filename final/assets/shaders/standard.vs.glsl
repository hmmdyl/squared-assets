#version 400 core

layout(location = 0) in vec3 Vertex;
layout(location = 1) in vec3 Normal;
layout(location = 2) in vec3 TexCoord;

out vec3 fVertex;
out vec3 fWorldPos;
out vec3 fNormal;
out vec3 fTexCoord;
out vec3 fTangent;

uniform mat4 ModelViewProjection;
uniform mat4 Model;

void main() {
	fWorldPos = (Model * vec4(Vertex, 1)).xyz;
	fVertex = Vertex;
	fNormal = (Model * vec4(Normal, 0)).xyz;
	
	vec3 xtan = vec3(0, 0, 1);
	vec3 ytan = vec3(1, 0, 0);
	vec3 ztan = vec3(1, 0, 0);
	
	vec3 n = Normal * Normal;
	vec3 tangent = xtan * n.x + ytan * n.y + ztan * n.z;
	
	fTangent = (Model * vec4(tangent, 0)).xyz;
	
	gl_Position = ModelViewProjection * vec4(Vertex, 1);
}