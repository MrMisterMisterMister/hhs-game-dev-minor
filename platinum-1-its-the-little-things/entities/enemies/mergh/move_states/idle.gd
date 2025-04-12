extends EnemyMoveState

@export_category("Transition States")
@export var idle_combat_state: EnemyMoveState
@export var walk_state: EnemyMoveState
@export var death_state: EnemyMoveState

var aggro_radius: float = 30.0


func enter(prev_state: EnemyMoveState) -> EnemyMoveState:
	super(prev_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	return null


func process(_delta: float) -> EnemyMoveState:
	if parent.stats.current_health <= 0.0:
		return death_state
	
	if in_attack_radius():
		return idle_combat_state
	
	if get_distance_to_target() <= aggro_radius:
		return walk_state
	
	return null


func physics_process(delta: float) -> EnemyMoveState:
	parent.velocity.y += parent.get_gravity().y * delta
	
	return null
