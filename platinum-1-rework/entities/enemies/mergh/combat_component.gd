class_name EnemyCombatComponent
extends Node

@export var parent: BaseEnemy

var in_attack_radius: bool = false
var spin_attack: bool = false


func get_hit(info: Dictionary) -> void:
	if "damage" in info:
		var damage = info["damage"]
		parent.stats.drain_health(damage)
		print("Mergh health: ", parent.stats.current_health)
