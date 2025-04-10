extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var run_state: MoveState
@export var jump_state: MoveState
@export var dash_state: MoveState
@export var hurt_state: MoveState

@export_category("Movement")
@export var walk_speed: float = 3.0


func enter(prev_state: MoveState, _info: Dictionary = {}) -> void:
	super(prev_state, _info)
	
	move_component.move_speed = walk_speed
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func input(_event: InputEvent) -> void:
	if Input.is_action_pressed("run"):
		SignalManager.player_move_state_changed.emit(run_state)
		return
	if Input.is_action_pressed("jump"):
		SignalManager.player_move_state_changed.emit(jump_state)
		return
	if Input.is_action_just_pressed("dash"):
		SignalManager.player_move_state_changed.emit(dash_state)
		return


func process(delta: float) -> void:
	parent.stamina += 8.5 * delta

	if combat_component.is_hurt:
		SignalManager.player_move_state_changed.emit(hurt_state, combat_component.hurt_info)
		return


func physics_process(delta: float) -> void:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	var movement = move_component.get_direction() * move_component.move_speed
	
	move_component.rotate_visual(delta)
	
	if movement == Vector3.ZERO:
		SignalManager.player_move_state_changed.emit(idle_state)
		return
	
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	
	parent.move_and_slide()
