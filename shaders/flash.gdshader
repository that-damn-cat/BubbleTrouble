shader_type canvas_item;

uniform bool enabled = false;
uniform vec3 flash_color : source_color = vec3(1.0,1.0,1.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (enabled) {
		color = vec4(flash_color, color.a);
	}
	
	COLOR = color;
}
