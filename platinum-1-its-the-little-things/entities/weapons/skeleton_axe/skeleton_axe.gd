extends base_weapon

var player_damagable: bool = false


func set_player_damagable(value: bool) -> void:
	player_damagable = value


func _on_hit_area_body_entered(body: Node3D) -> void:
	if not body is CollisionObject3D:
		return
	if body.collision_layer == 2 and player_damagable:
		body.combat_component.get_hit({
			"damage": damage,
		})
