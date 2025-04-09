extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var walk_state: MoveState
@export var jump_state: MoveState
@export var dash_state: MoveState

@export_category("Movement")
@export var run_speed: float = 5.0


func enter(prev_state: MoveState) -> MoveState:
	super(prev_state)
	
	move_component.move_speed = run_speed
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	
	return null


func input(_event: InputEvent) -> MoveState:
	if not Input.is_action_pressed("run"):
		return walk_state
	if Input.is_action_pressed("jump"):
		return jump_state
	if Input.is_action_just_pressed("dash"):
		return dash_state
	
	return null


func physics_process(delta: float) -> MoveState:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	var movement = move_component.get_direction() * move_component.move_speed
	
	move_component.rotate_visual(delta)
	
	if movement == Vector3.ZERO:
		return idle_state
	
	if parent.stamina <= 5:
		return walk_state
	
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	parent.move_and_slide()
	
	return null
