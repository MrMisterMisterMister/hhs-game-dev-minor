class_name EnemyMoveStateMachine
extends Node

@export var initial_state: EnemyMoveState

var current_state: EnemyMoveState
var previous_state: EnemyMoveState


func init(parent: BaseEnemy, target: Node3D, animation_tree: AnimationTree, combat_component: Node) -> void:
	for child in get_children():
		child.parent = parent
		child.target = target
		child.animation_tree = animation_tree
		child.combat_component = combat_component
	
	# Initialize to the default state
	change_state(initial_state)


## Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: EnemyMoveState) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state)
	
	#if previous_state:
		#print("enemy state machine: ", self.name, " │ previous state: ", previous_state.name)
		#print("enemy state machine: ", self.name, " │ current state: ", current_state.name)


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
