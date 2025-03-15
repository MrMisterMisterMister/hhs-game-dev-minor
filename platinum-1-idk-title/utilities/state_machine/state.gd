class_name State
extends Node

@export var animation_name: String

var parent: CharacterBody3D
var animation_player: AnimationPlayer
var move_component: Node
var move_speed: float = 0


func enter() -> void:
	animation_player.play(animation_name)


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(_delta: float) -> State:
	return null


func get_movement_input() -> Vector2:
	return move_component.get_movement_input()


func get_movement_direction() -> Vector3:
	return move_component.get_movement_direction()


func get_visuals_direction() -> Vector3:
	return move_component.get_visuals_direction()


func get_jump() -> float:
	return move_component.get_jump()


func get_gravity() -> float:
	return move_component.get_gravity(parent.velocity)


func rotate_visuals(_delta: float) -> void:
	move_component.rotate_visuals(_delta)
