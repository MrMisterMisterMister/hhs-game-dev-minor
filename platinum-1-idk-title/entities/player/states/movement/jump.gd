extends State

@export var idle_state: State
@export var walk_state: State
@export var run_state: State


func enter() -> void:
	super()
	parent.velocity.y = get_jump()


func physics_process(_delta: float) -> State:
	parent.velocity.y += get_gravity() * _delta
	
	if Input.is_action_pressed("run"):
		move_speed = run_state.run_speed
	else:
		move_speed = walk_state.walk_speed
	
	var movement = get_movement_direction() * move_speed
	
	rotate_visuals(_delta)
	
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
