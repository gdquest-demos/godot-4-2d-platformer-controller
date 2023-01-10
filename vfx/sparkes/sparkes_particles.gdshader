shader_type canvas_item;

uniform sampler2D spritesheet_sampler : filter_nearest_mipmap;

varying float id;
varying vec4 custom;

void vertex(){
	custom = INSTANCE_CUSTOM;
	id = float(INSTANCE_ID);
}

void fragment() {
	float s = (1.0 / 3.0);
	float t_id = mod(round(custom.z * 5.0), 3.0);
	COLOR.a = texture(spritesheet_sampler, UV * vec2(s, 1.0) + vec2(s * t_id, 0.0)).a;
}
