extends EnemyMoveState

@export_category("Transition States")
@export var idle_state: EnemyMoveState
@export var fall_state: EnemyMoveState
@export var death_state: EnemyMoveState

@onready var immobile_timer: Timer = $ImmobileTimer


func enter(prev_state: EnemyMoveState) -> EnemyMoveState:
	super(prev_state)
	
	if parent.stats.current_health <= 0.0:
		SignalManager.player_move_state_changed.emit(death_state)
		return
	
	immobile_timer.start()
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	return null


func physics_process(delta: float) -> EnemyMoveState:
	parent.velocity.y += parent.get_gravity().y * delta
	
	if not immobile_timer.is_stopped():
		return
	
	combat_component.is_hurt = false
	
	SignalManager.player_move_state_changed.emit(idle_state)
	
	return null
