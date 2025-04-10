extends Control


func _ready() -> void:
	SignalManager.settings_loaded.emit()
	UIManager.add_ui("uid://cpgictxlt4acq")


func _on_start_button_up() -> void:
	GameManager.start_game()


func _on_settings_button_up() -> void:
	get_tree().root.get_node("/root/UIManager/SettingsMenu").visible = true

func _on_exit_button_up() -> void:
	get_tree().quit()
