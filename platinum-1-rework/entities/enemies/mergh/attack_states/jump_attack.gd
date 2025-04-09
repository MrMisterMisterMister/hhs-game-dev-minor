extends EnemyAttackState

@export_category("Transition States")
@export var jump_attack_state: EnemyAttackState


func enter(prev_state: EnemyAttackState) -> void:
	super(prev_state)
	
	animation_tree.get("parameters/AttackStateMachine/playback").travel(self.name)
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	await get_tree().create_timer(2.3).timeout
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
