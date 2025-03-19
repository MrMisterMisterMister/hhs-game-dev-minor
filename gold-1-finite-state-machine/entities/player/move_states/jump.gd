extends State

@export_category("Transition States")
@export var idle_state: State
@export var walk_state: State
@export var run_state: State


func enter(previous_state: State) -> void:
	super(previous_state)
	
	parent.velocity.y = move_component.get_jump_velocity()


func physics_process(delta: float) -> State:
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
