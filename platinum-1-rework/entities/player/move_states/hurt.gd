extends MoveState


func enter(prev_state: MoveState) -> MoveState:
	super(prev_state)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	return null
