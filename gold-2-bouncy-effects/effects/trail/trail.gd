extends GPUParticles2D

@export var gravity_strength := 98


func set_particle_gravity(direction: Vector2) -> void:
	process_material.set("gravity", direction.normalized() * gravity_strength)


func set_gradient_color(point: int, color: Color) -> void:
	var grad: GradientTexture1D = process_material.get("color_ramp")
	grad.gradient.set_color(point, color)
