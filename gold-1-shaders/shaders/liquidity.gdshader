shader_type spatial;

uniform vec3 color: source_color = vec3(0.0, 0.0, 0.128);
uniform sampler2D texture1: repeat_enable, filter_linear;
uniform sampler2D texture2: repeat_enable, filter_linear;
uniform vec2 direction1 = vec2(1.0, 0.0);
uniform vec2 direction2 = vec2(0.0, 1.0);
uniform float speed1: hint_range(0.0, 1.0) = 0.03;
uniform float speed2: hint_range(0.0, 1.0) = 0.02;


void fragment() {
	vec2 offset1 = speed1 * direction1 * TIME;
	vec2 offset2 = speed2 * direction2 * TIME;
	vec3 normal1 = texture(texture1, UV + offset1).rgb;
	vec3 normal2 = texture(texture2, UV + offset2).rgb;
	vec3 final_normal = mix(normal1, normal2, 0.5);
	NORMAL_MAP = final_normal;
	ALBEDO = color;
	METALLIC = 0.9;
	ROUGHNESS = 0.1;
}
