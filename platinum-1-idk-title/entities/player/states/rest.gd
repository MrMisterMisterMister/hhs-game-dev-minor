extends State

@export var idle_state: State

var can_transition: bool


func enter() -> void:
	super()
	parent.velocity.x = 0
	can_transition = false


func input(_event: InputEvent) -> State:
	if get_jump() != 0 and parent.is_on_floor():
		return idle_state
	
	return null

func physics_process(_delta: float) -> State:
	parent.velocity.y += get_gravity() * _delta
	
	parent.move_and_slide()
	
	return null
