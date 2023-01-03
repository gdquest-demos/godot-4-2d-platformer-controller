shader_type canvas_item;

uniform sampler2D noise_sampler : repeat_enable;
uniform sampler2D gradient_color : repeat_enable;

void fragment() {
	COLOR.rgb = texture(gradient_color, vec2(UV.x - TIME, 0.0)).rgb;
	float n = texture(noise_sampler, (UV * vec2(0.1, 0.25)) + vec2(-TIME * 0.45, TIME * 0.25) ).x;
	float edge = sin(UV.y * PI) * (1.0 - UV.x);
	edge = smoothstep(0.0, 0.5, edge);
	COLOR.a *= smoothstep(0.24, 0.25, n * edge);

}
