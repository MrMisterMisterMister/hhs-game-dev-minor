extends Node

var is_attacking: bool


func get_hit(info: Dictionary) -> void:
	if "damage" in info:
		print("Taken ", info["damage"], " damage.")
