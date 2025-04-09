class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var previous_state: State


## Initialize the state machine by giving each child state a reference to the
## parent object it belongs to and enter the default starting_state.
func init(parent: CharacterBody3D, animation_player: AnimationPlayer) -> void:
	for child in get_children():
		child.parent = parent
		child.animation_player = animation_player
	
	# Initialize to the default state
	change_state(initial_state)


## Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State, info: Dictionary = {}) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state)
	
	SignalManager.player_state_changed.emit(current_state, previous_state)


# Pass through function for the Player to call,
# handling state changes as needed.
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)


func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
