class_name AttackState
extends Node

var parent: Node3D
var animation_tree: AnimationTree
var previous_state: AttackState
var move_component: Node
var combat_component: Node


func enter(prev_state: AttackState) -> void:
	previous_state = prev_state
	
	if self.name == "Standby":
		return


func exit() -> void:
	pass


func input(_event: InputEvent) -> AttackState:
	return null


func process(_delta: float) -> AttackState:
	return null


func physics_process(_delta: float) -> AttackState:
	return null
