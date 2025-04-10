class_name AttackStateMachine
extends Node

@export var initial_state: AttackState

var current_state: AttackState
var previous_state: AttackState
var move_component: Node
var combat_component: Node


func init(parent: CharacterBody3D, animation_tree: AnimationTree, move_cpm: Node, combat_cpm:Node) -> void:
	for child in get_children():
		child.parent = parent
		child.animation_tree = animation_tree
		child.move_component = move_cpm
		child.combat_component = combat_cpm
	
	# Initialize to the default state
	change_state(initial_state)


## Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: AttackState) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state)
	
	#print(self.name, ": ", current_state.name)
	
	#SignalManager.attack_state_changed.emit(current_state, previous_state)


# Pass through function for the Player to call,
# handling state changes as needed.
func physics_process(delta: float) -> void:
	var new_state
	if current_state:
		new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func input(event: InputEvent) -> void:
	var new_state
	if current_state:
		new_state = await current_state.input(event)
	if new_state:
		change_state(new_state)


func process(delta: float) -> void:
	var new_state
	if current_state:
		new_state = await current_state.process(delta)
	if new_state:
		change_state(new_state)
