#version 400 core

uniform sampler2D Diffuse;

out vec4 Fragment;

void main()
{
	Fragment.rgb = vec3(0, 0.5, 1);
	Fragment.a = 1;
}