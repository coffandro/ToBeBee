shader_type spatial;

uniform vec3 flash_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float alpha = 1.0;

void fragment() {
	ALBEDO = flash_color;
	ALPHA = alpha;
}
