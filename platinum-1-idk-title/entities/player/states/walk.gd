extends State

@export var idle_state: State
@export var run_state: State
@export var jump_state: State

@export var walk_speed: float = 3.0

func enter() -> void:
	super()
	move_speed = walk_speed


func input(_event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		return run_state
	
	return null


func physics_process(_delta: float) -> State:
	if get_jump() and parent.is_on_floor():
		return jump_state
	
	parent.velocity.y += get_gravity() * _delta
	
	var movement = get_movement_direction() * move_speed
	
	rotate_visuals(_delta)
	
	if movement == Vector3.ZERO:
		return idle_state
	
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	
	
	parent.move_and_slide()
	
	return null
