extends State

@export_category("Transition States")
@export var idle_state: State


func enter(previous_state: State) -> void:
	super(previous_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0


func process(delta: float) -> State:
	if not animation_player.is_playing():
		return idle_state
	
	return null


func physics_process(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	return null
