shader_type spatial;

uniform float move_speed = 1.0;
uniform float wave_speed = 15.0;
uniform float wave_y = 10.0;
uniform float wave_x = 0.25;
uniform float radius = 5.0;


void vertex() {
	VERTEX += vec3(
		cos(TIME * move_speed) * radius,
		sin(TIME * move_speed) * radius,
		sin(TIME * move_speed)
	);

	VERTEX.x += sin(TIME * wave_speed + VERTEX.y * wave_y) * wave_x;
}

void light() {
	float light_intensity = max(0.0, dot(NORMAL, LIGHT));
	DIFFUSE_LIGHT = ALBEDO * LIGHT_COLOR * light_intensity;
}
