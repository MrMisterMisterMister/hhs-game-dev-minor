extends Control


func _on_exit_button_button_up() -> void:
	SignalManager.game_settings.emit()
