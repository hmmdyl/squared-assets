#version 400 core

uniform sampler2D Diffuse;

in vec2 fTexCoord;

out vec4 Fragment;

void main()
{
	Fragment.rgb = texture(Diffuse, fTexCoord).rgb;
	//Fragment.rgb = vec3(0, 0.5, 1);
	Fragment.a = 1;
}