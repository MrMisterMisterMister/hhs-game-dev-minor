class_name EnemyEnemyAttackStateMachine
extends Node

@export var initial_state: EnemyAttackState

var current_state: EnemyAttackState
var previous_state: EnemyAttackState


func init(parent: BaseEnemy, animation_tree: AnimationTree, combat_component: Node) -> void:
	for child in get_children():
		child.parent = parent
		child.animation_tree = animation_tree
		child.combat_component = combat_component
	
	# Initialize to the default state
	change_state(initial_state)


## Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: EnemyAttackState) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state)
	
	#if previous_state:
		#print("enemy state machine: ", self.name, " │ previous state: ", previous_state.name)
		#print("enemy state machine: ", self.name, " │ current state: ", current_state.name)


func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func process(delta: float) -> void:
	var new_state = await current_state.process(delta)
	if new_state:
		change_state(new_state)
