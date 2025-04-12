extends EnemyMoveState


func enter(prev_state: EnemyMoveState) -> EnemyMoveState:
	super(prev_state)
	
	combat_component.in_attack_radius = false
	
	SignalManager.boss_defeated.emit()
	
	animation_tree.get("parameters/MoveStateMachine/playback").travel(self.name)
	
	parent.collision_shape.queue_free()
	
	return null


func physics_process(delta: float) -> EnemyMoveState:
	parent.velocity.y += parent.get_gravity().y * delta
	
	return null
