class_name MoveStateMachine
extends Node

@export var initial_state: MoveState

var current_state: MoveState
var previous_state: MoveState


func init(parent: CharacterBody3D, animation_tree: AnimationTree, move_cpm: Node, combat_cpm: Node) -> void:
	for child in get_children():
		child.parent = parent
		child.animation_tree = animation_tree
		child.move_component = move_cpm
		child.combat_component = combat_cpm
	
	# Initialize to the default state
	change_state(initial_state)


## Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: MoveState) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state)
	
	SignalManager.move_state_changed.emit(current_state, previous_state)


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
