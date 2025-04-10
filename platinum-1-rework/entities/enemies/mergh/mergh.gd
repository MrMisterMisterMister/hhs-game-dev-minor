class_name Mergh
extends BaseEnemy

@onready var move_state_machine: EnemyMoveStateMachine = $MoveStateMachine
@onready var attack_state_machine: EnemyEnemyAttackStateMachine = $AttackStateMachine
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var combat_component: Node = $CombatComponent


func _ready() -> void:
	move_state_machine.init(self, target, animation_tree, combat_component)
	attack_state_machine.init(self, animation_tree, combat_component)
	
	stats.init()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	move_state_machine.process(delta)
	attack_state_machine.process(delta)


func _physics_process(delta: float) -> void:
	move_state_machine.physics_process(delta)
	attack_state_machine.physics_process(delta)
