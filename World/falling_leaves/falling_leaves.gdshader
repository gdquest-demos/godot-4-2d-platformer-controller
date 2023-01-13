shader_type particles;

uniform sampler2D alpha_time_sampler;
uniform float spawn_width = 400.0;

float rand(float n){return fract(sin(n) * 43758.5453123);}

void start() {
	// Place start code here.
	CUSTOM.y = TIME;
	CUSTOM.x = rand(float(INDEX));
	TRANSFORM[3].xy = vec2(0.0);
	TRANSFORM[3].x += ((rand(TIME) - 0.5) * 2.0) * spawn_width;
	VELOCITY.y = 50.0 * CUSTOM.x;
	VELOCITY.x = 0.0;
}

void process() {
	VELOCITY.x = sin(TIME + float(INDEX) * CUSTOM.x) * 100.0;
	float rot = (VELOCITY.x * 0.01);
	float scale = 0.06 - (CUSTOM.x * 0.01);
	CUSTOM.z = sin(VELOCITY.x * 0.1);
	TRANSFORM[0].x = cos(rot) * scale;
	TRANSFORM[0].y = sin(rot) * scale;
	TRANSFORM[1].x = -sin(rot) * scale;
	TRANSFORM[1].y = cos(rot) * scale;
	
	float alpha_percent = (TIME - CUSTOM.y) / LIFETIME;
	CUSTOM.w = texture(alpha_time_sampler, vec2(clamp(alpha_percent, 0.0, 1.0), 0.0)).x;
}
