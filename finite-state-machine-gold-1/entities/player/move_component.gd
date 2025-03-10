extends Node

@export var player: CharacterBody3D
@export var visuals: Node3D

@export_group("Gravity")
@export var rise_height: float = 2.0
@export var rise_time_to_peak: float = 0.5
@export var fall_time_to_ground: float = 0.667

var rise_velocity: float = (2.0 * rise_height) / rise_time_to_peak
var rise_gravity: float = (-2.0 * rise_height) / (rise_time_to_peak * rise_time_to_peak)
var fall_gravity: float = (-2.0 * rise_height) / (fall_time_to_ground * fall_time_to_ground)


func get_movement_input() -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward')


func get_movement_direction() -> Vector3:
	return (player.transform.basis * Vector3(get_movement_input().x, 0, get_movement_input().y)).normalized()

func rotate_visuals(_delta) -> void:
	var visual_dir = Vector3(get_movement_input().x, 0, get_movement_input().y).normalized()
	visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(visual_dir.x, visual_dir.z), _delta * 10)

func get_jump() -> float:
	return rise_velocity if Input.is_action_just_pressed('jump') else 0


func get_gravity(velocity: Vector3) -> float:
	return rise_gravity if velocity.y > 0 else fall_gravity
