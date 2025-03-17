extends Control

var resolutions = SettingsManager.default_settings.RESOLUTIONS

@onready var fullscreen_checkbox: CheckBox = $MarginContainer/ScrollContainer/VBoxContainer/FullscreenSetting/FullscreenCheckbox
@onready var borderless_checkbox: CheckBox = $MarginContainer/ScrollContainer/VBoxContainer/BorderlessSetting/BorderlessCheckbox
@onready var v_sync_checkbox: CheckBox = $MarginContainer/ScrollContainer/VBoxContainer/VSyncSetting/VSyncCheckbox
@onready var resolution_button: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/Resolution/ResolutionButton


func _ready() -> void:
	for resolution in resolutions:
		resolution_button.add_item(resolution)
		
	SignalManager.display_settings_loaded.connect(_load_display_settings)


func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	var window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(window_mode)
	
	fullscreen_checkbox.button_pressed = toggled_on
	SignalManager.fullscreen_changed.emit(toggled_on)


func _on_borderless_checkbox_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
	
	borderless_checkbox.button_pressed = toggled_on
	SignalManager.borderless_changed.emit(toggled_on)


func _on_v_sync_checkbox_toggled(toggled_on: bool) -> void:
	var v_sync = DisplayServer.VSYNC_ENABLED if toggled_on else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(v_sync)
	
	v_sync_checkbox.button_pressed = toggled_on
	SignalManager.v_sync_changed.emit(toggled_on)


func _on_resolution_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(resolutions.values()[index])
	_centre_window()
	
	resolution_button.selected = index
	SignalManager.resolution_changed.emit(index)


func _centre_window():
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)


func _load_display_settings() -> void:
	_on_fullscreen_checkbox_toggled(SettingsManager.fullscreen)
	_on_borderless_checkbox_toggled(SettingsManager.borderless)
	_on_v_sync_checkbox_toggled(SettingsManager.v_sync)
	_on_resolution_button_item_selected(SettingsManager.resolution)
