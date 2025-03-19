extends State

@export_category("Transition States")
@export var walk_state: State
@export var run_state: State
@export var jump_state: State
@export var rest_state: State


func enter(previous_state: State) -> void:
	super(previous_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0


func input(_event: InputEvent) -> State:
	if parent.is_on_floor():
		if move_component.get_jump_velocity() != 0:
			return jump_state
		if move_component.get_direction() != Vector3.ZERO:
			return walk_state
		if Input.is_action_pressed("run"):
			return run_state
		if Input.is_action_pressed("rest"):
			return rest_state
	
	return null


func physics_process(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	parent.move_and_slide()
	
	return null
