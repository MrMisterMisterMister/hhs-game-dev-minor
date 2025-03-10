extends State

@export var walk_state: State
@export var run_state: State
@export var jump_state: State
@export var rest_state: State


func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0


func input(_event: InputEvent) -> State:
	if get_jump() != 0 and parent.is_on_floor():
		return jump_state
	if get_movement_direction() != Vector3.ZERO:
		return walk_state
	if Input.is_action_pressed("run"):
		return run_state
	if Input.is_action_pressed("rest"):
		return rest_state
	
	return null


func physics_process(_delta: float) -> State:
	parent.velocity.y += get_gravity() * _delta
	parent.move_and_slide()
	
	return null
