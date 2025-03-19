extends State

@export_category("Transition States")
@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export_category("Movement")
@export var walk_speed: float = 3.0


func enter(previous_state: State) -> void:
	super(previous_state)
	
	move_component.move_speed = walk_speed


func input(_event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		return run_state
	
	return null


func physics_process(delta: float) -> State:
	if move_component.get_jump_velocity() != 0 and parent.is_on_floor():
		return jump_state
	
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	var movement = move_component.get_direction() * move_component.move_speed
	
	move_component.rotate_visual(delta)
	
	if movement == Vector3.ZERO:
		return idle_state
	
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	parent.move_and_slide()
	
	return null
