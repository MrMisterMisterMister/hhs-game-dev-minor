class_name EnemyMoveState
extends Node

var parent: CharacterBody3D
var animation_tree: AnimationTree
var previous_state: EnemyMoveState
var move_component: Node
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
