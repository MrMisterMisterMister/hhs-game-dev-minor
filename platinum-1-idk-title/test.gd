extends Control

# UI References
@onready var fullscreen_checkbox: CheckBox = $SettingsContainer/FullscreenSetting/FullscreenCheckbox
@onready var borderless_checkbox: CheckBox = $SettingsContainer/BorderlessSetting/BorderlessCheckbox
@onready var resolution_option: OptionButton = $SettingsContainer/ResolutionSetting/ResolutionOption
@onready var dynamic_resolution_checkbox: CheckBox = $SettingsContainer/DynamicResolutionSetting/DynamicResolutionCheckbox
@onready var dynamic_resolution_slider: HSlider = $SettingsContainer/DynamicResolutionSetting/ScaleSlider
@onready var apply_button: Button = $SettingsContainer/ApplyButton

# Settings storage
var settings = {
	"fullscreen": false,
	"borderless": false,
	"resolution_index": 0,
	"dynamic_resolution": false,
	"dynamic_scale": 1.0
}

# Available resolutions (width, height)
var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

func _ready():
	# Load saved settings if available
	load_settings()
	
	# Setup resolution options
	setup_resolution_options()
	
	# Connect signals
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	borderless_checkbox.toggled.connect(_on_borderless_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	dynamic_resolution_checkbox.toggled.connect(_on_dynamic_resolution_toggled)
	dynamic_resolution_slider.value_changed.connect(_on_scale_changed)
	apply_button.pressed.connect(_on_apply_pressed)
	
	# Initialize UI with current settings
	update_ui_from_settings()

func setup_resolution_options():
	resolution_option.clear()
	
	for i in range(resolutions.size()):
		var res = resolutions[i]
		resolution_option.add_item(str(res.x) + "x" + str(res.y), i)
	
	# Add current desktop resolution if not in the list
	var current_res = DisplayServer.window_get_size()
	var has_current = false
	
	for res in resolutions:
		if res.x == current_res.x and res.y == current_res.y:
			has_current = true
			break
	
	if not has_current:
		resolutions.append(current_res)
		resolution_option.add_item(str(current_res.x) + "x" + str(current_res.y), resolutions.size() - 1)

func update_ui_from_settings():
	fullscreen_checkbox.button_pressed = settings.fullscreen
	borderless_checkbox.button_pressed = settings.borderless
	resolution_option.selected = settings.resolution_index
	dynamic_resolution_checkbox.button_pressed = settings.dynamic_resolution
	dynamic_resolution_slider.value = settings.dynamic_scale
	
	# Update dynamic resolution slider visibility
	dynamic_resolution_slider.visible = settings.dynamic_resolution

func _on_fullscreen_toggled(toggled_on):
	settings.fullscreen = toggled_on
	# If fullscreen is enabled, disable borderless option
	if toggled_on:
		settings.borderless = false
		borderless_checkbox.button_pressed = false
		borderless_checkbox.disabled = true
	else:
		borderless_checkbox.disabled = false

func _on_borderless_toggled(toggled_on):
	settings.borderless = toggled_on
	# If borderless is enabled, disable fullscreen option
	if toggled_on:
		settings.fullscreen = false
		fullscreen_checkbox.button_pressed = false
		fullscreen_checkbox.disabled = true
	else:
		fullscreen_checkbox.disabled = false

func _on_resolution_selected(index):
	settings.resolution_index = index

func _on_dynamic_resolution_toggled(toggled_on):
	settings.dynamic_resolution = toggled_on
	dynamic_resolution_slider.visible = toggled_on

func _on_scale_changed(value):
	settings.dynamic_scale = value

func _on_apply_pressed():
	apply_settings()
	save_settings()

func apply_settings():
	# Get selected resolution
	var selected_resolution = resolutions[settings.resolution_index]
	
	# Apply window mode (fullscreen, borderless, or windowed)
	if settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif settings.borderless:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		# Center the window
		var screen_size = DisplayServer.screen_get_size()
		var window_position = (screen_size - selected_resolution) / 2
		DisplayServer.window_set_position(window_position)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	# Apply resolution
	if not settings.fullscreen:  # In fullscreen, we use the native resolution
		DisplayServer.window_set_size(selected_resolution)
	
	# Apply dynamic resolution if enabled
	if settings.dynamic_resolution:
		get_viewport().scaling_3d_scale = settings.dynamic_scale
	else:
		get_viewport().scaling_3d_scale = 1.0

func load_settings():
	if FileAccess.file_exists("user://display_settings.cfg"):
		var config = ConfigFile.new()
		var err = config.load("user://display_settings.cfg")
		
		if err == OK:
			settings.fullscreen = config.get_value("display", "fullscreen", false)
			settings.borderless = config.get_value("display", "borderless", false)
			settings.resolution_index = config.get_value("display", "resolution_index", 0)
			settings.dynamic_resolution = config.get_value("display", "dynamic_resolution", false)
			settings.dynamic_scale = config.get_value("display", "dynamic_scale", 1.0)

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("display", "fullscreen", settings.fullscreen)
	config.set_value("display", "borderless", settings.borderless)
	config.set_value("display", "resolution_index", settings.resolution_index)
	config.set_value("display", "dynamic_resolution", settings.dynamic_resolution)
	config.set_value("display", "dynamic_scale", settings.dynamic_scale)
	
	config.save("user://display_settings.cfg")
