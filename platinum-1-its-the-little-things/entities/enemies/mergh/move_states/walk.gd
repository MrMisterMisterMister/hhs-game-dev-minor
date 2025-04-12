extends EnemyMoveState

@export_category("Transition States")
@export var idle_state: EnemyMoveState
@export var idle_combat_state: EnemyMoveState
@export var death_state: EnemyMoveState

var walk_speed: float = 2.5
var deaggro_radius: float = 30.0
var action_radius: float = 3.0


func enter(prev_state: EnemyMoveState) -> EnemyMoveState:
	super(prev_state)
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	return null


func process(_delta: float) -> EnemyMoveState:
	if parent.stats.current_health <= 0.0:
		return death_state
	
	if in_attack_radius():
		return idle_combat_state
	if get_distance_to_target() > deaggro_radius:
		return idle_state
	
	return null


func physics_process(delta: float) -> EnemyMoveState:
	parent.velocity.y += parent.get_gravity().y * delta
	
	move_toward_target(walk_speed, delta)
	
	return null
