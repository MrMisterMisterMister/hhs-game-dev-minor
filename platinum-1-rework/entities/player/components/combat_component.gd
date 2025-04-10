extends Node

var is_attacking: bool
var is_hurt: bool
var hurt_info: Dictionary


func get_hit(info: Dictionary) -> void:
	is_hurt = true
	hurt_info = info
