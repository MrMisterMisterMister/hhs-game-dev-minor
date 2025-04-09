extends EnemyAttackState

@export_category("Transition States")
@export var jump_attack_state: EnemyAttackState


func enter(prev_state: EnemyAttackState) -> void:
	super(prev_state)


func process(_delta: float) -> EnemyAttackState:
	if  combat_component.is_attacking:
		return jump_attack_state
	
	return null
