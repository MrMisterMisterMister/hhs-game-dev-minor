extends Node

@export_category("Entity")
@export var parent: Node3D
@export var visual: Node3D
@export var rotation_smoothness: float = 6.0

@export_category("Gravity")
@export var rise_height: float = 2.0
@export var rise_time_to_peak: float = 0.5
@export var fall_time_to_ground: float = 0.3

var rise_velocity: float = (2.0 * rise_height) / rise_time_to_peak
var rise_gravity: float = (-2.0 * rise_height) / (rise_time_to_peak * rise_time_to_peak)
var fall_gravity: float = (-2.0 * rise_height) / (fall_time_to_ground * fall_time_to_ground)

var move_speed: float


## Get player input
func get_movement_input() -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward')


## Get player direction
func get_direction() -> Vector3:
	var input = get_movement_input()
	return parent.transform.basis * (Vector3(input.x, 0, input.y)).normalized()


## Rotate the player's visual node based on the player's input direction
func rotate_visual(delta: float) -> void:
	var input = get_movement_input()
	
	if input.length_squared() == 0:
		return

	var visual_direction = Vector3(input.x, 0, input.y).normalized()
	visual.rotation.y = lerp_angle(visual.rotation.y, atan2(visual_direction.x, visual_direction.z), rotation_smoothness * delta)


func get_jump_velocity() -> float:
	return rise_velocity if Input.is_action_just_pressed('jump') else 0.0


func get_gravity(velocity: Vector3) -> float:
	return rise_gravity if velocity.y > 0 else fall_gravity
