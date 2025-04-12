extends MoveState

@export_category("Transition States")
@export var walk_state: MoveState
@export var run_state: MoveState
@export var jump_state: MoveState
@export var dash_state: MoveState
@export var rest_state: MoveState
@export var hurt_state: MoveState


func enter(prev_state: MoveState, _info: Dictionary = {}) -> void:
	super(prev_state, _info)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func input(_event: InputEvent) -> void:
	if parent.is_on_floor():
		if move_component.get_jump_velocity() != 0:
			SignalManager.player_move_state_changed.emit(jump_state)
			return
		if move_component.get_direction() != Vector3.ZERO:
			SignalManager.player_move_state_changed.emit(walk_state)
			return
		if Input.is_action_pressed("run"):
			SignalManager.player_move_state_changed.emit(run_state)
			return
		if Input.is_action_pressed("rest"):
			SignalManager.player_move_state_changed.emit(rest_state)
			return
		if Input.is_action_just_pressed("dash"):
			SignalManager.player_move_state_changed.emit(dash_state)
			return


func process(delta: float) -> void:
	parent.stats.regen_stamina(delta)
	
	if combat_component.is_hurt:
		SignalManager.player_move_state_changed.emit(hurt_state, combat_component.hurt_info)
		return


func physics_process(delta: float) -> void:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	parent.move_and_slide()
