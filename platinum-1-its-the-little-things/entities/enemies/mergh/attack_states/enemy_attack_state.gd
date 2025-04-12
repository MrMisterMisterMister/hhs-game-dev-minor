class_name EnemyAttackState
extends Node

var parent: Node3D
var animation_tree: AnimationTree
var previous_state: EnemyAttackState
var combat_component: Node


func enter(prev_state: EnemyAttackState) -> void:
	previous_state = prev_state
	
	if self.name == "Standby":
		return


func exit() -> void:
	pass


func process(_delta: float) -> EnemyAttackState:
	return null


func physics_process(_delta: float) -> EnemyAttackState:
	return null
