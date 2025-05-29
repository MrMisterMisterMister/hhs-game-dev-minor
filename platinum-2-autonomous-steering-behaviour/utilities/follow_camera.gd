extends Camera2D

@export var target: Node2D


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
