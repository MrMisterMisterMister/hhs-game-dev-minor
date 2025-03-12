extends Control


func _on_restart_button_button_up() -> void:
	SignalManager.game_restarted.emit()
