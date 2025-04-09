extends AttackState

@export_category("Transition States")
@export var standby_state: AttackState
@export var one_hand_stab_state: AttackState


func enter(prev_state: AttackState) -> void:
	super(prev_state)
	
	combat_component.is_attacking = true
	$AttackTimer.start()


func input(_event: InputEvent) -> AttackState:
	if Input.is_action_just_pressed("attack"):
		if combat_component.is_attacking:
			await animation_tree.animation_finished
			return one_hand_stab_state
	
	return null


func process(_delta: float) -> AttackState:
	if not combat_component.is_attacking:
		return standby_state
	
	return null


func _on_attack_timer_timeout() -> void:
	combat_component.is_attacking = false
