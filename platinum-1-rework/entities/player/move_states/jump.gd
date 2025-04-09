extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var walk_state: MoveState
@export var run_state: MoveState


func enter(prev_state: MoveState) -> MoveState:
	super(prev_state)
	
	parent.velocity.y = move_component.get_jump_velocity()
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	
	return null


func process(delta: float) -> MoveState:
	parent.stamina += 8.5 * delta
	
	return null


func physics_process(delta: float) -> MoveState:
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
	
	if parent.is_on_floor():
		if movement == Vector3.ZERO:
			return idle_state
		elif Input.is_action_pressed("run"):
			return run_state
		else:
			return walk_state
	
	return null
