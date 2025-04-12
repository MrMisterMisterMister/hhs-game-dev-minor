class_name EnemyMoveState
extends Node

var parent: CharacterBody3D
var target: Node3D
var animation_tree: AnimationTree
var previous_state: EnemyMoveState
var combat_component: Node


func enter(prev_state: EnemyMoveState) -> EnemyMoveState:
	previous_state = prev_state
	
	return null


func exit() -> void:
	pass


func process(_delta: float) -> EnemyMoveState:
	return null


func physics_process(_delta: float) -> EnemyMoveState:
	return null


################################################################################
# The following are non spefic FSM-methods, i.e. utility methods
# that may be used by multiple states.
################################################################################


func get_direction_to_player() -> Vector3:
	return parent.global_position.direction_to(target.global_position)


func get_distance_to_target() -> float:
	return parent.global_position.distance_to(target.global_position)


func move_toward_target(speed: float, delta: float) -> void:
	var dir: Vector3 = get_direction_to_player()
	
	look_toward_target(delta)
	parent.velocity = Vector3(dir.x, 0, dir.z) * speed
	
	parent.move_and_slide()


func look_toward_target(delta: float) -> void:
	var dir: Vector3 = get_direction_to_player()
	var target_angle: float = atan2(dir.x, dir.z)
	
	# Calculate angle difference (-PI to PI range)
	var angle_diff: float = wrapf(target_angle - parent.rotation.y, -PI, PI)
	
	# Determine rotation speed based on how far behind the player is
	var base_speed: float = 2.0 
	var behind_threshold: float = PI/2
	var max_speed: float = 8.0   # Max rotation speed when directly behind
	
	# Faster rotation when player is behind
	var rotation_speed: float
	if abs(angle_diff) > behind_threshold:
		# Scale speed based on how far behind (from threshold to PI)
		var behind_factor: float = (abs(angle_diff) - behind_threshold) / (PI - behind_threshold)
		rotation_speed = lerp(base_speed, max_speed, behind_factor)
	else:
		rotation_speed = base_speed
	
	# Apply rotation with dynamic speed
	parent.rotation.y = lerp_angle(parent.rotation.y, target_angle, rotation_speed * delta)


func in_attack_radius() -> bool:
	combat_component.in_attack_radius = get_distance_to_target() < 5.5
	return combat_component.in_attack_radius
