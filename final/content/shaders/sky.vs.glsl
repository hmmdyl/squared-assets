#version 430 core
 
layout(location = 0) in vec3 Vertex;

out float fHeight;
out vec3 fWorldPos;

uniform mat4 MVP;
uniform mat4 Model;
uniform float MaxHeight;

void main()
{
	gl_Position = MVP * vec4(Vertex, 1);
	//fHeight = clamp(Vertex.y, 0, 1);

	fWorldPos = (Model * vec4(Vertex, 1)).xyz;
	fHeight = clamp(Vertex.y, 0, 1);
}