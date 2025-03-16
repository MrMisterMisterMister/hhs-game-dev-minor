extends Node


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		SignalManager.game_paused.emit()
