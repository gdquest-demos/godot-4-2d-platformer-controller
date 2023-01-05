shader_type canvas_item;

uniform sampler2D gradient_color : repeat_enable;
uniform float intensity = 0.0;

void fragment() {
	vec3 base_color = texture(TEXTURE, UV).rgb;
	vec3 multi_color = texture(gradient_color, vec2(UV.y + TIME, 0.0)).rgb * intensity;
	
	COLOR.rgb += multi_color;
}
