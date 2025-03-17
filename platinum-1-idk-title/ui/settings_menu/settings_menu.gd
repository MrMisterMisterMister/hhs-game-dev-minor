extends Control


func _on_save_button_button_up() -> void:
	SignalManager.settings_saved.emit()
	SignalManager.game_settings.emit()


func _on_exit_button_button_up() -> void:
	SignalManager.game_settings.emit()
