extends EnemyMoveState

@export_category("Transition States")
@export var walk_state: EnemyMoveState
@export var run_state: EnemyMoveState


func enter(prev_state: EnemyMoveState) -> EnemyMoveState:
	super(prev_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/EnemyMoveStateMachine/playback").travel(self.name)
	
	return null


func physics_process(delta: float) -> EnemyMoveState:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	var dir := parent.global_position.direction_to(parent.target.global_position)
	parent.velocity = dir * 20 * delta
	
	parent.move_and_slide()
	
	return null
