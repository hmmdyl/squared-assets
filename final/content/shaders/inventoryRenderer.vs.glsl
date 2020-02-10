#version 400 core

layout(location = 0) in vec2 Vertex;

uniform vec2 Position;
uniform vec2 Size;
uniform mat4 MVP;

out vec2 fTexCoord;

void main()
{
	vec2 v = Position + (Vertex * Size);
	fTexCoord = Vertex;
	gl_Position = MVP * vec4(v, 0, 1);
}