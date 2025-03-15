extends Control


func _on_start_button_button_up() -> void:
	SignalManager.game_started.emit()


func _on_settings_button_button_up() -> void:
	pass # Replace with function body.


func _on_exit_button_button_up() -> void:
	SignalManager.game_exited.emit()
