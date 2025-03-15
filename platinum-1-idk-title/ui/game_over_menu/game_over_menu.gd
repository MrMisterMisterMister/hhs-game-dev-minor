extends Control


func _on_restart_button_button_up() -> void:
	SignalManager.game_restarted.emit()


func _on_settings_button_button_up() -> void:
	SignalManager.game_over.emit()


func _on_exit_button_button_up() -> void:
	SignalManager.game_ended.emit()
