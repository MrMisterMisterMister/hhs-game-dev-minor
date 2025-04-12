extends MoveState


func enter(prev_state: MoveState, info: Dictionary = {}) -> void:
	super(prev_state, info)
	
	SignalManager.player_defeated.emit()
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	UIManager.change_ui("uid://c8j31ikta0x45")


func physics_process(delta: float) -> void:
	parent.velocity.y += parent.get_gravity().y * delta
	
	parent.move_and_slide()
