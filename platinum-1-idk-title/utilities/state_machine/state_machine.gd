class_name StateMachine
extends Node

signal state_changed(current_state: State)

@export var initial_state: State

var current_state: State


func init(parent: CharacterBody3D, animation_player: AnimationPlayer, move_component: Node) -> void:
	for child in get_children():
		child.parent = parent
		child.animation_player = animation_player
		child.move_component = move_component
	
	change_state(initial_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	state_changed.emit(current_state)
	print("Current State: ", current_state.name)


func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)


func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)


func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)
