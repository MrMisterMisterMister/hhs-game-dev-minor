class_name Mergh
extends BaseEnemy


func _physics_process(delta: float) -> void:
	var dir: Vector3 = self.global_position.direction_to(target.global_position)
	self.velocity = dir * 20 * delta
