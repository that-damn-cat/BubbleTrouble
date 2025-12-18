shader_type canvas_item;

uniform bool enabled = false;
uniform float ice_strength : hint_range(0.0, 1.0) = 0.7;
uniform float sparkle_strength : hint_range(0.0, 1.0) = 0.35;
uniform vec3 ice_tint : source_color = vec3(0.75, 0.9, 1.0);
uniform float black_threshold : hint_range(0.0, 0.2) = 0.05;
uniform vec3 black_replace_color : source_color = vec3(0.9, 0.95, 1.0);
uniform float time_speed = 1.0;

float hash(vec2 p) {
	p = fract(p * vec2(127.1, 311.7));
	p += dot(p, p + 19.19);
	return fract(p.x * p.y);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Detect outline pixels
	float luminance = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	float is_black = step(luminance, black_threshold);

	// Pixel Space
	vec2 pixel_uv = floor(UV * 48.0) / 48.0;
	float rnd = hash(pixel_uv * 20.0);

	// Sparkle
	float wave = sin(TIME * time_speed + rnd * 6.2831);
	float sparkle = smoothstep(0.6, 1.0, wave);

	// Ice coloring
	vec3 icy_color = mix(tex.rgb, ice_tint, ice_strength);
	icy_color += sparkle * sparkle_strength * rnd;

	// Replace Outlines
	vec3 final_rgb = mix(icy_color, black_replace_color, is_black);
	
	if (enabled) {
		COLOR = vec4(final_rgb, tex.a);
	} else {
		COLOR = COLOR;
	}
}