extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var walk_state: MoveState
@export var run_state: MoveState
@export var dash_state: MoveState
@export var fall_state: MoveState
@export var hurt_state: MoveState


func enter(prev_state: MoveState, _info: Dictionary= {}) -> void:
	super(prev_state, _info)
	
	parent.velocity.y = move_component.get_jump_velocity()
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash"):
		SignalManager.player_move_state_changed.emit(dash_state)
		return


func process(delta: float) -> void:
	if Input.is_action_pressed("run"):
		parent.stats.drain_stamina(delta * 5)
	else:
		parent.stats.regen_stamina(delta)
	
	if combat_component.is_hurt:
		SignalManager.player_move_state_changed.emit(hurt_state, combat_component.hurt_info)
		return

func physics_process(delta: float) -> void:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	if Input.is_action_pressed("run"):
		move_component.move_speed = run_state.run_speed
	else:
		move_component.move_speed = walk_state.walk_speed
	
	var movement = move_component.get_direction() * move_component.move_speed
	
	move_component.rotate_visual(delta)
	
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	
	parent.move_and_slide()
	
	if parent.velocity.y < 0:
		SignalManager.player_move_state_changed.emit(fall_state)
		return
	
	if parent.is_on_floor():
		if movement == Vector3.ZERO:
			SignalManager.player_move_state_changed.emit(idle_state)
			return
		elif Input.is_action_pressed("run"):
			SignalManager.player_move_state_changed.emit(run_state)
			return
		else:
			return
