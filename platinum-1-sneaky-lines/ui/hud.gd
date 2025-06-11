class_name Hud
extends Control

signal game_restarted
signal game_won

enum GameType {
	WON,
	LOST,
	OOPS,
}

var has_ended: bool = false

@onready var label: Label = $MarginContainer/VBoxContainer/Label


func _ready() -> void:
	game_won.connect(game_ended)


func _input(event: InputEvent) -> void:
	if has_ended:
		return

	if Input.is_action_just_pressed("ui_cancel"):
		visible = not visible
		get_tree().paused = not get_tree().paused

		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			_:
				Input.MOUSE_MODE_VISIBLE

		get_viewport().set_input_as_handled()


func game_ended(type: GameType, message: String = "", color: Color = Color.WHITE) -> void:
	has_ended = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	match type:
		GameType.WON:
			label.text = "You Won" if not message else message
			label.add_theme_color_override("font_color", Color.GREEN)
			label.add_theme_font_size_override("font_size", 75)
		GameType.LOST:
			label.text = "You Lost" if not message else message
			label.add_theme_color_override("font_color", color)
			label.add_theme_font_size_override("font_size", 50)
		GameType.OOPS:
			label.text = "Oops, my bad" if not message else message
			label.add_theme_color_override("font_color", Color.DARK_SLATE_GRAY)
			label.add_theme_font_size_override("font_size", 75)

	visible = true
	get_tree().paused = true


func _on_restart_button_up() -> void:
	has_ended = false
	visible = false
	get_tree().paused = false
	label.text = "Game Paused"
	game_restarted.emit()


func _on_exit_button_up() -> void:
	get_tree().quit()
