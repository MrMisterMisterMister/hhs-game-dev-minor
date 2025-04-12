extends Node

var player: Player


func start_game() -> void:
	SceneManager.change_scene("uid://ip5r63007c10")
	UIManager.change_ui("uid://cpgictxlt4acq")
	UIManager.add_ui("uid://7qp73kfrh6pm")
	UIManager.add_ui("uid://dfqkutwq7g6id")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func return_to_main_menu() -> void:
	SceneManager.change_scene("uid://dn5hf5v6q0e8y")
	UIManager.clear_ui()
	
	UIManager.prev_mouse_mode = Input.mouse_mode
	get_tree().paused = false
