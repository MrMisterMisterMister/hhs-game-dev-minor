extends AttackState

@export_category("Transition States")
@export var standby_state: AttackState
@export var stab_state: AttackState

var will_transition: bool = false


func enter(prev_state: AttackState) -> void:
	super(prev_state)
	
	combat_component.is_attacking = true
	$AttackTimer.start()
	
	animation_tree.get("parameters/AttackStateMachine/playback").travel(self.name)
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)



func input(_event: InputEvent) -> AttackState:
	if Input.is_action_just_pressed("attack"):
		if combat_component.is_attacking and not will_transition:
			will_transition = true
			await animation_tree.animation_finished
			will_transition = false
			return stab_state
	
	return null


func process(_delta: float) -> AttackState:
	if combat_component.is_hurt:
		animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		return standby_state
	
	if not combat_component.is_attacking:
		return standby_state
	
	return null


func _on_attack_timer_timeout() -> void:
	combat_component.is_attacking = false
