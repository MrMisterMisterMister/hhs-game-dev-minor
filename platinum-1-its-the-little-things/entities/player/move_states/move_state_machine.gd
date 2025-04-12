class_name MoveStateMachine
extends Node

@export var initial_state: MoveState

var current_state: MoveState
var previous_state: MoveState


func init(parent: CharacterBody3D,
		animation_tree: AnimationTree,
		move_cpm: Node,
		combat_cpm: Node) -> void:
	
	for child in get_children():
		child.parent = parent
		child.animation_tree = animation_tree
		child.move_component = move_cpm
		child.combat_component = combat_cpm
	
	SignalManager.player_move_state_changed.connect(_change_state)
	
	# Initialize to the default state
	_change_state(initial_state)


## Change to the new state by first calling any exit logic on the current state.
func _change_state(new_state: MoveState, info: Dictionary = {}) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	
	current_state.enter(previous_state, info)


# Pass through function for the Player to call,
# handling state changes as needed.
func physics_process(delta: float) -> void:
	if not current_state:
		push_error(self.name, ": no state set.")
	current_state.physics_process(delta)


func input(event: InputEvent) -> void:
	if not current_state:
		push_error(self.name, ": no state set.")
	current_state.input(event)


func process(delta: float) -> void:
	if not current_state:
		push_error(self.name, ": no state set.")
	current_state.process(delta)
