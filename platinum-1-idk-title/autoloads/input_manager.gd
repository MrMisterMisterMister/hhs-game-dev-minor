extends Node


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_game"):
		SignalManager.game_paused.emit()
