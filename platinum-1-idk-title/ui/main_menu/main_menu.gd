extends Control


func _process(delta: float) -> void:
	if LevelManager.current_level_id == 0:
		AudioManager.play_music("uid://ed7jpvmwuuli")
	else:
		AudioManager.stop_music()


func _on_start_button_button_up() -> void:
	SignalManager.game_started.emit()


func _on_settings_button_button_up() -> void:
	SignalManager.game_settings.emit()


func _on_exit_button_button_up() -> void:
	SignalManager.game_exited.emit()
