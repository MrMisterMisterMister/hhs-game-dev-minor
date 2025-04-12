extends Control


func _ready() -> void:
	UIManager.change_ui("uid://cpgictxlt4acq")
	
	$BGMusic.play(1.1)

func _on_start_button_up() -> void:
	GameManager.start_game()
	queue_free()


func _on_settings_button_up() -> void:
	UIManager.show_ui("SettingsMenu")


func _on_exit_button_up() -> void:
	await get_tree().create_timer(0.2).timeout
	
	get_tree().quit()
