extends State

@export_category("Transition States")
@export var rise_state: State


func enter(previous_state: State) -> void:
	super(previous_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0


func input(_event: InputEvent) -> State:
	if move_component.get_jump_velocity() != 0 and parent.is_on_floor():
		return rise_state
	
	return null


func physics_process(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta

	return null
