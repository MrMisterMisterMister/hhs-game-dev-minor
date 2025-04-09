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


func move_toward_target(speed: float) -> void:
	var dir: Vector3 = get_direction_to_player()
	var target_angle: float = Vector2(dir.x, dir.z).angle()
	
	parent.rotation.y = -target_angle + PI/2
	parent.velocity = Vector3(dir.x, 0, dir.z) * speed
	
	parent.move_and_slide()


func can_attack() -> bool:
	combat_component.is_attacking = get_distance_to_target() < 4.5
	return combat_component.is_attacking
