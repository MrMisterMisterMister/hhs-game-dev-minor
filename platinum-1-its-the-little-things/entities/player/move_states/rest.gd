extends MoveState

@export_category("Transition States")
@export var rise_state: MoveState


func enter(prev_state: MoveState, _info: Dictionary = {}) -> void:
	super(prev_state, _info)

	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func input(_event: InputEvent) -> void:
	if move_component.get_jump_velocity() != 0 and parent.is_on_floor():
		SignalManager.player_move_state_changed.emit(rise_state)
		return


func process(delta: float) -> void:
	parent.stats.regen_health(delta)
	parent.stats.regen_stamina(delta)


func physics_process(delta: float) -> void:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
