extends AttackState

@export_category("Transition States")
@export var one_hand_chop: AttackState


func enter(prev_state: AttackState) -> void:
	super(prev_state)


func input(_event: InputEvent) -> AttackState:
	if Input.is_action_just_pressed("attack"):
		return one_hand_chop
	
	return null
