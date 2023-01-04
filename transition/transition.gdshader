shader_type canvas_item;
uniform sampler2D star_sdf_sampler;
uniform float rotation = 0.0;
uniform vec2 offset = vec2(0.0);
uniform vec2 ratio = vec2(1.0);
uniform float scale = 1.0;

// UV Rotation method
// Source: https://gist.github.com/ayamflow/c06bc0c8a64f985dd431bd0ac5b557cd
vec2 rotateUV(vec2 uv, float r)
{
    float mid = 0.5;
    return vec2(
        cos(r) * (uv.x - mid) + sin(r) * (uv.y - mid) + mid,
        cos(r) * (uv.y - mid) - sin(r) * (uv.x - mid) + mid
    );
}

void fragment() {
	vec2 uv_ratio = UV * ratio - offset;
	float star_sdf = texture(star_sdf_sampler, rotateUV((uv_ratio - 0.5) / scale + 0.5, rotation)).a;
	COLOR.a = step(star_sdf, 0.5);
}
