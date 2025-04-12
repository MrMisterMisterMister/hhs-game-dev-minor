extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var fall_state: MoveState
@export var death_state: MoveState

var _has_initial_velocity: bool = false

@onready var immobile_timer: Timer = $ImmobileTimer


func enter(prev_state: MoveState, info: Dictionary = {}) -> void:
	super(prev_state, info)
	
	if "damage" in info:
		var damage = info["damage"]
		parent.stats.drain_health(damage)
	if "initial_velocity" in info:
		parent.velocity = info["initial_velocity"]
	
	if parent.stats.current_health <= 0.0:
		SignalManager.player_move_state_changed.emit(death_state)
		return
	
	immobile_timer.start()
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func physics_process(delta: float) -> void:
	parent.velocity.y += parent.get_gravity().y * delta
	
	parent.move_and_slide()
	
	if not immobile_timer.is_stopped():
		return
	
	combat_component.is_hurt = false
	
	SignalManager.player_move_state_changed.emit(idle_state)
	
	
