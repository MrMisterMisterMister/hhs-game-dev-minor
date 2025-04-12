extends Control


func _on_resume_button_up() -> void:
	UIManager.handle_pause()


func _on_restart_button_up() -> void:
	get_tree().paused = false
	
	GameManager.start_game()


func _on_settings_button_up() -> void:
	UIManager.show_ui("SettingsMenu")


func _on_exit_button_up() -> void:
	GameManager.return_to_main_menu()
