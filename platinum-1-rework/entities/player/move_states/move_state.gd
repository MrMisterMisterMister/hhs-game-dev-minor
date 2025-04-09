class_name MoveState
extends Node

var parent: CharacterBody3D
var animation_tree: AnimationTree
var previous_state: MoveState
var move_component: Node
var combat_component: Node


func enter(prev_state: MoveState) -> MoveState:
	previous_state = prev_state
	
	return null


func exit() -> void:
	pass


func input(_event: InputEvent) -> MoveState:
	return null


func process(_delta: float) -> MoveState:
	return null


func physics_process(_delta: float) -> MoveState:
	return null
