extends AttackState

@export_category("Transition States")
@export var standby_state: AttackState


func enter(prev_state: AttackState) -> void:
	super(prev_state)
	
	animation_tree.get("parameters/AttackStateMachine/playback").travel(self.name)
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func process(_delta: float) -> AttackState:
	if combat_component.is_hurt:
		animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		return standby_state
	
	await animation_tree.animation_finished
	return standby_state
