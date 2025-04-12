extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade_to_black")
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_restart_button_up() -> void:
	GameManager.start_game()


func _on_exit_button_up() -> void:
	GameManager.return_to_main_menu()
