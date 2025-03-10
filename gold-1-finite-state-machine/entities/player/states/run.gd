extends State

@export var idle_state: State
@export var walk_state: State
@export var jump_state: State

@export var run_speed: float = 5.0


func enter() -> void:
	super()
	move_speed = run_speed


func input(_event: InputEvent) -> State:
	if not Input.is_action_pressed("run"):
		return walk_state
	
	return null


func physics_process(_delta: float) -> State:
	if get_jump() != 0 and parent.is_on_floor():
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
