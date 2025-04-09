extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState


func enter(prev_state: MoveState) -> MoveState:
	super(prev_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	return null


func process(_delta: float) -> MoveState:
	#if not animation_player.is_playing():
		#return idle_state

	return null


func physics_process(delta: float) -> MoveState:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	return null
