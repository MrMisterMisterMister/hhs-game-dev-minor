extends Control



func _on_resume_button_button_up() -> void:
	SignalManager.game_resumed.emit()


func _on_restart_button_button_up() -> void:
	SignalManager.game_restarted.emit()


func _on_settings_button_button_up() -> void:
	pass # Replace with function body.


func _on_exit_button_button_up() -> void:
	pass # Replace with function body.
