extends EnemyAttackState

@export_category("Transition States")
@export var standby_state: EnemyAttackState


func enter(prev_state: EnemyAttackState) -> void:
	super(prev_state)
	
	animation_tree.get("parameters/AttackStateMachine/playback").travel(self.name)
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func process(_delta: float) -> EnemyAttackState:
	if not animation_tree.get("parameters/AttackOneShot/active"):
		return standby_state
	
	return null
