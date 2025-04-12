extends Control

const RESOLUTIONS = {
	"1152x648": Vector2i(1152, 648),
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440),
	"3840x2160": Vector2i(3840, 2160)
}

var config_path: String = "user://settings.cfg"
var config_name: String = "display"
var display_settings: Dictionary = {
		"fullscreen": false,
		"borderless": false,
		"v_sync": true,
		"resolution": 0
}

@onready var full_screen: Button = %Fullscreen
@onready var borderless: Button = %Borderless
@onready var v_sync: Button = %VSync
@onready var resolution: OptionButton = %Resolution


func _ready() -> void:
	for res in RESOLUTIONS:
		resolution.add_item(res)


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	var window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN \
		if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED
	
	DisplayServer.window_set_mode(window_mode)
	
	full_screen.text = "On" if toggled_on else "Off"
	
	display_settings["fullscreen"] = toggled_on
	_save_settings()


func _on_borderless_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
	
	borderless.text = "On" if toggled_on else "Off"
	
	display_settings["borderless"] = toggled_on
	_save_settings()


func _on_v_sync_toggled(toggled_on: bool) -> void:
	var v_sync_toggle = DisplayServer.VSYNC_ENABLED \
	if toggled_on else DisplayServer.VSYNC_DISABLED
	
	DisplayServer.window_set_vsync_mode(v_sync_toggle)
	
	v_sync.text = "On" if toggled_on else "Off"
	
	display_settings["v_sync"] = toggled_on
	_save_settings()


func _on_resolution_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTIONS.values()[index])
	_centre_window()
	
	resolution.selected = index
	
	display_settings["resolution"] = index
	_save_settings()


func _centre_window():
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)


func _save_settings() -> void:
	var config = ConfigFile.new()
	config.load(config_path) # Load existing settings
	
	for settings_name in display_settings:
		config.set_value(config_name, settings_name, display_settings[settings_name])
	
	config.save(config_path)


func load_settings() -> void:
	var config = ConfigFile.new()
	
	if config.load(config_path) == OK and config.has_section(config_name):
		for settings_name in config.get_section_keys(config_name):
			var saved_settings = config.get_value(config_name, settings_name)
			display_settings[settings_name] = saved_settings
	
	_on_fullscreen_toggled(display_settings["fullscreen"])
	_on_borderless_toggled(display_settings["borderless"])
	_on_v_sync_toggled(display_settings["v_sync"])
	_on_resolution_item_selected(display_settings["resolution"])
