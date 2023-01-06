shader_type canvas_item;

uniform float screen_ratio = 1.0;
uniform float ratio = 1.0;
uniform sampler2D sparkles_noise_sampler : filter_nearest, repeat_enable;
uniform sampler2D color_gradient_sampler : repeat_enable;
uniform vec3 base_color : source_color = vec3(1.0);
uniform vec3 highlight_color : source_color = vec3(1.0);

uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);

uniform sampler2D displacement_noise_sampler : repeat_enable;
uniform sampler2D normal_noise_sampler : repeat_enable;


// https://www.reddit.com/r/godot/comments/iwocl2/comment/hx1p5un/?utm_source=reddit&utm_medium=web2x&context=3
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float get_stars(vec2 uv, vec2 screen_uv, float offset, float time){
	vec3 noise = texture(sparkles_noise_sampler, uv + screen_uv * offset).xyz;
	vec3 directions_hsv = rgb2hsv(noise);
	directions_hsv.x += time;
	directions_hsv = hsv2rgb(directions_hsv);
	return directions_hsv.x;
}

vec3 overlay(vec3 base, vec3 blend){
	vec3 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}


void fragment() {
	vec2 ratio_screen_uv = (SCREEN_UV * screen_ratio);
	vec2 ratio_uv = UV * vec2(ratio, 1.0);
	float t = mod(TIME * 0.2, 1.0);
	
	// Compute flow normal
	vec2 scaled_ratio_uv = ratio_uv * 0.15;
	vec2 flow_vec = texture(displacement_noise_sampler, scaled_ratio_uv).xy;
	
	float base_flow_time = TIME * 0.1;
	
	float flow_time_1 = mod(base_flow_time, 1.0);
	float flow_time_2 = mod(base_flow_time + 0.5, 1.0);
	
	float sin_flow_time = abs(flow_time_1 * 2.0 - 1.0);
	
	vec2 flow_uv_1 = scaled_ratio_uv + (flow_vec * flow_time_1);
	vec2 flow_uv_2 = scaled_ratio_uv + (flow_vec * flow_time_2);
	
	vec3 flow_normal_1 = texture(normal_noise_sampler, flow_uv_1).rgb;
	vec3 flow_normal_2 = texture(normal_noise_sampler, flow_uv_2).rgb;
	vec3 flow_normal = mix(flow_normal_1, flow_normal_2, sin_flow_time);
	
	float def = 0.05;
	
	vec2 deformation = (flow_normal.xy * def) - def / 2.0;
	
	float r = texture(SCREEN_TEXTURE, SCREEN_UV + deformation + vec2(SCREEN_PIXEL_SIZE * r_displacement), 0.0).r;
	float g = texture(SCREEN_TEXTURE, SCREEN_UV + deformation + vec2(SCREEN_PIXEL_SIZE * g_displacement), 0.0).g;
	float b = texture(SCREEN_TEXTURE, SCREEN_UV + deformation + vec2(SCREEN_PIXEL_SIZE * b_displacement), 0.0).b;
	
	float stars_1 = get_stars(ratio_uv, ratio_screen_uv, 0.2, t);
	float stars_2 = get_stars(ratio_uv, ratio_screen_uv, 0.4, t);
	
	vec3 screen_color = vec3(r,g,b);
	float highlight = (flow_normal.x - flow_normal.y);
	float stars = stars_1 + stars_2;
	
	vec3 color_soup = texture(color_gradient_sampler, flow_normal.xy * 5.0).rgb;
	
	vec3 sky_color = mix(base_color, highlight_color, highlight) + stars;

	
	float g_x = sin((UV.x + deformation.x) * PI);
	float g_y = sin((UV.y + deformation.y) * PI);
	
	COLOR.rgb = overlay(screen_color, sky_color);
	COLOR.a = step(0.05, g_x * g_y);
	
}
