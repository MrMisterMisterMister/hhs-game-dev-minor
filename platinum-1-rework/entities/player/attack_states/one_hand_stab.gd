extends AttackState

@export_category("Transition States")
@export var standby_state: AttackState


func enter(prev_state: AttackState) -> void:
	super(prev_state)


func process(_delta: float) -> AttackState:
	await animation_tree.animation_finished
	return standby_state
