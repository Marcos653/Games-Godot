shader_type canvas_item;

uniform vec3 color: source_color = vec3(1);
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	vec4 target_color = mix(current_color, vec4(color, current_color.a), progress);
	COLOR = target_color;
}
