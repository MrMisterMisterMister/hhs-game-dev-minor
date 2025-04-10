extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var fall_state: MoveState

@onready var immobile_timer: Timer = $ImmobileTimer


func enter(prev_state: MoveState, info: Dictionary = {}) -> void:
	super(prev_state, info)
	
	if "damage" in info:
		var damage = info["damage"]
		parent.stats.drain_health(damage)
		print("Current health: ", parent.stats.current_health)
	if "knockback" in info:
		print("Knockback: ", info["knockback"])
	
	immobile_timer.start()
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func physics_process(delta: float) -> void:
	parent.velocity.y += parent.get_gravity().y * delta
	
	if not immobile_timer.is_stopped():
		return
	
	combat_component.is_hurt = false
	
	SignalManager.player_move_state_changed.emit(idle_state)
