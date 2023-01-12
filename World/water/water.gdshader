shader_type canvas_item;

uniform vec3 edge_color : source_color = vec3(1.0);
uniform vec3 highlight_color : source_color = vec3(1.0);
uniform vec3 water_color : source_color = vec3(1.0);

uniform sampler2D wave_texture_sampler : repeat_enable, filter_nearest;
uniform float height = 1.0;
uniform float ratio = 1.0;
uniform float wave_scale = 32.0;



vec3 swap_values(float value){
	float values[3] = float[3] (0.0, 0.5, 1.0);
	vec3 replace_colors[3] = vec3[3] (edge_color, highlight_color, water_color);
	for (int i = 0; i < 5; i ++) {
		if (distance(value, values[i]) <= 0.1){
			return replace_colors[i];
		}
	}
	return vec3(1.0);
}

void fragment() {
	float scale = (height / wave_scale);
	
	float wave_y = sin(UV.x * ratio * scale * PI * 0.65 - TIME) * 0.1;
	
	vec4 wave_texture = texture(wave_texture_sampler, UV * vec2(1.0, 2.0) * vec2(ratio, 1.0) * scale + vec2(TIME * 0.45, wave_y));

	float top_mask = 1.0 - step(-wave_y, UV.y * scale);
	float bottom_mask = step(-wave_y + 0.45, UV.y * scale);

	COLOR.a = clamp(wave_texture.a + bottom_mask - top_mask, 0.0, 1.0);
	
	float wave_base = clamp(wave_texture.x + bottom_mask, 0.0, 1.0);
	
	vec3 wave_color = swap_values(wave_base);
	
	float def = 0.005;
	float half_def = def / 2.0;
	
	vec3 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, sin(UV.x * ratio * scale * PI + TIME) * def + half_def)).rgb;
	
	COLOR.rgb = mix(screen_color, wave_color, (1.0 - float(wave_base > 0.5)) + UV.y * 0.4 + 0.6);
}
