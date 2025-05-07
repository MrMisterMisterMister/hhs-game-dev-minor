class_name Ball
extends CharacterBody2D

@export var is_ball_one := false
@export var colour_ball_one := Color('#D8D8F6')
@export var colour_ball_two := Color('#B18FCF')
@export var speed := 75.0
@export var camera: CameraShake
@export var blur_effect: ColorRect

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var trail: GPUParticles2D = $Trail
@onready var trail_two: GPUParticles2D = $TrailTwo
@onready var bounce_particle_resource: PackedScene = preload("uid://dlfn3ikdoidsf")


func _ready() -> void:
	# Set the position
	global_position.y = (get_viewport_rect().size.y/2)
	if is_ball_one:
		global_position.x = (get_viewport_rect().size.x/4) + (get_viewport_rect().size.y/2)
	else:
		global_position.x = (get_viewport_rect().size.x/4)

	# Set velocity
	velocity.x = -speed
	velocity.y = randi_range(-15, 15) # randomize that starting velocity a bit.

	# Set the correct colours
	polygon_2d.color = colour_ball_one if is_ball_one else colour_ball_two

	if is_ball_one:
		remove_child(trail_two)
		trail_two.queue_free()
	else:
		remove_child(trail)
		trail.queue_free()


func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	# If there is a collision, bounce the ball and toggle the collided tile
	if collision:
		# Bounce the velocity to the ball collides
		velocity = velocity.bounce(collision.get_normal())
		_spawn_bounce_particle()
		camera.apply_shake(1.0)
		_squash()

		# If the collision is with a tile, toggle it
		if collision.get_collider() is Tile:
			collision.get_collider().toggle(self)
			blur_effect.get_node("AnimationPlayer").play("blur")

	if trail: trail.set_particle_gravity(-velocity)
	if trail_two: trail_two.set_particle_gravity(-velocity)


func _get_collision_layer() -> int:
	return collision_layer


func _spawn_bounce_particle() -> void:
	var bounce_particles: GPUParticles2D = bounce_particle_resource.instantiate()
	get_parent().add_child(bounce_particles)

	bounce_particles.global_position = position
	bounce_particles.rotation = velocity.angle()
	bounce_particles.emitting = true
	bounce_particles.process_material.set("gravity", velocity.normalized() * 98)

	bounce_particles.finished.connect(bounce_particles.queue_free)


func _squash() -> void:
	var squash = 1.0 - (velocity.length() / 10000.0)
	scale.x = 1.0 + squash * 0.3
	scale.y = 1.0 - squash * 0.3

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
