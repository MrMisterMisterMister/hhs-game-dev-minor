extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_button_button_up() -> void:
	SignalManager.game_restarted.emit()


func _on_exit_button_button_up() -> void:
	get_tree().quit()
