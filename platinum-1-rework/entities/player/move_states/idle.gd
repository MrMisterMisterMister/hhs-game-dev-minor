extends MoveState

@export_category("Transition States")
@export var walk_state: MoveState
@export var run_state: MoveState
@export var jump_state: MoveState
@export var dash_state: MoveState
@export var rest_state: MoveState


func enter(prev_state: MoveState) -> MoveState:
	super(prev_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	return null


func input(_event: InputEvent) -> MoveState:
	if parent.is_on_floor():
		if move_component.get_jump_velocity() != 0:
			return jump_state
		if move_component.get_direction() != Vector3.ZERO:
			return walk_state
		if Input.is_action_pressed("run"):
			return run_state
		if Input.is_action_pressed("rest"):
			return rest_state
		if Input.is_action_just_pressed("dash"):
			return dash_state
	
	return null


func physics_process(delta: float) -> MoveState:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	parent.move_and_slide()
	
	return null
