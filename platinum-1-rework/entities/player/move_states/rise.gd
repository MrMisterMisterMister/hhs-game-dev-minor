extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState


func enter(prev_state: MoveState, _info: Dictionary = {}) -> void:
	super(prev_state, _info)
	
	parent.velocity.x = 0
	parent.velocity.z = 0
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)


func process(_delta: float) -> void:
	await animation_tree.animation_finished
	
	SignalManager.player_move_state_changed.emit(idle_state)


func physics_process(delta: float) -> void:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
