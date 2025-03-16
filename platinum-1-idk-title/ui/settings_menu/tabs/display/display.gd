extends Control

var resolutions = {
	"1152x648": Vector2i(1152, 648),
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440),
	"3840x2160": Vector2i(3840, 2160)
}

@onready var resolution_button: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/Resolution/ResolutionButton


func _ready() -> void:
	for resolution in resolutions:
		resolution_button.add_item(resolution)


func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	if  toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_borderless_checkbox_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)


func _on_resolution_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(resolutions.values()[index])
	centre_window()


func centre_window():
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)
