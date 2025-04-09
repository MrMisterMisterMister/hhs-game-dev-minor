extends EnemyAttackState

@export_category("Transition States")
@export var jump_attack_state: EnemyAttackState

var can_attack: bool = true

@onready var attack_timer: Timer = $AttackTimer


func enter(prev_state: EnemyAttackState) -> void:
	super(prev_state)
	
	attack_timer.start()


func process(_delta: float) -> EnemyAttackState:
	if not can_attack:
		return null
	
	if combat_component.in_attack_radius:
		can_attack = false
		return jump_attack_state
	
	return null


func _on_attack_timer_timeout() -> void:
	can_attack = true
