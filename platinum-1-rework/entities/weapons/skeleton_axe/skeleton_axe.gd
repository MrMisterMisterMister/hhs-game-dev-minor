extends base_weapon


func player_damagable(value: bool) -> void:
	SignalManager.player_damagable.emit(value)


func _on_hit_area_body_entered(body: Node3D) -> void:
	if not body is CollisionObject3D:
		return
	if body.collision_layer == 2:
		body.combat_component.get_hit({
			"damage": damage,
		})
