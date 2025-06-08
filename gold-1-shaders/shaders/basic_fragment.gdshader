shader_type spatial;

uniform float tiling = 4.0;
uniform float wave_speed = 5.0;
uniform float color_speed = 1.0;
uniform vec4 color1: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color2: source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform sampler2D texture_albedo;


void fragment() {
	vec2 wave_uv = UV * tiling;
	wave_uv.y += sin(wave_uv.x * 50.0 + TIME * wave_speed) * 0.025;

	float mix_factor = sin((TIME * color_speed) + 1.0) * 0.5;

	vec4 tex_color = texture(texture_albedo, wave_uv);
	ALBEDO = tex_color.rgb * mix(color1.rgb, color2.rgb, mix_factor);
}

void light() {
	float light_intensity = max(0.0, dot(NORMAL, LIGHT));
	DIFFUSE_LIGHT = ALBEDO * LIGHT_COLOR * light_intensity;
}
