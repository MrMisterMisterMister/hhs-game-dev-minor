class_name MoveState
extends Node

var parent: CharacterBody3D
var animation_tree: AnimationTree
var previous_state: MoveState
var move_component: Node
var combat_component: Node


func enter(prev_state: MoveState, _info: Dictionary = {}) -> void:
	previous_state = prev_state


func exit() -> void:
	pass


func input(_event: InputEvent) -> void:
	pass


func process(_delta: float) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass
