class_name State
extends Node

@export var animation_name: String

var parent: Node3D
var move_component: Node
var animation_player: AnimationPlayer
var previous_state: State


func enter(prev_state: State) -> void:
	animation_player.play(animation_name)
	previous_state = prev_state


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(_delta: float) -> State:
	return null
