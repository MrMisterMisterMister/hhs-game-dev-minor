extends Node

var fullscreen: bool
var borderless: bool
var v_sync: bool
var resolution: int
var keybinds: Dictionary
var volume: Dictionary

var default_settings: Resource = preload("uid://0nifploiycfn")
var config = ConfigFile.new()


func _ready() -> void:
	_connect_signals()


func _save_settings() -> void:
	var settings = _export_settings()
	
	for tab in settings:
		for item in settings[tab]:
			config.set_value(tab, item, settings[tab][item]) # e.g. {display, fullscreen, 1}
	
	config.save(default_settings.SETTINGS_FILE_PATH)


func _load_settings() -> void:
	var err = config.load(default_settings.SETTINGS_FILE_PATH)
	
	if err == OK:
		if config.has_section("display"):
			fullscreen = config.get_value("display", "fullscreen")
			borderless = config.get_value("display", "borderless")
			v_sync = config.get_value("display", "v-sync")
			resolution = config.get_value("display", "resolution")
		if config.has_section("controls"): 
			keybinds = config.get_value("controls", "keybinds")
		if config.has_section("sound"):
			volume = config.get_value("sound", "volume")
	else:
		_load_defaut_settings()
	
	SignalManager.display_settings_loaded.emit()
	SignalManager.control_settings_loaded.emit()
	SignalManager.sound_settings_loaded.emit()


func _load_defaut_settings() -> void:
	fullscreen = default_settings.DEFAULT_FULLSCREEN
	borderless = default_settings.DEFAULT_BORDERLESS
	v_sync = default_settings.DEFAULT_V_SYNC
	resolution = default_settings.DEFAULT_RESOLUTION
	volume = default_settings.DEFAULT_VOLUME


func _export_settings() -> Dictionary:
	return {
		"display" : _export_display_settings(),
		"controls" : {"keybinds" : keybinds},
		"sound": {"volume": volume},
	}


func _export_display_settings() -> Dictionary:
	return {
		"fullscreen" : fullscreen,
		"borderless" : borderless,
		"v-sync" : v_sync,
		"resolution" : resolution,
	}


func _update_fullscreen(toggle: bool) -> void:
	fullscreen = toggle


func _update_borderless(toggle: bool) -> void:
	borderless = toggle


func _update_v_sync(toggle: bool) -> void:
	v_sync = toggle


func _update_resolution(index: int) -> void:
	resolution = index


func _update_keybind(action: String, event: InputEvent) -> void:
	if event is InputEventKey:
		keybinds[action] = {
			"type": "key",
			"keycode": event.keycode,
			"physical_keycode": event.physical_keycode,
			}
	elif event is InputEventMouseButton:
		keybinds[action] = {
			"type": "mouse_button",
			"button_index": event.button_index
			}


func _update_volume(bus_name: String, value: float) -> void:
	volume[bus_name] = value


func _connect_signals() -> void:
	SignalManager.fullscreen_changed.connect(_update_fullscreen)
	SignalManager.borderless_changed.connect(_update_borderless)
	SignalManager.v_sync_changed.connect(_update_v_sync)
	SignalManager.resolution_changed.connect(_update_resolution)
	SignalManager.keybind_changed.connect(_update_keybind)
	SignalManager.volume_changed.connect(_update_volume)
	SignalManager.settings_saved.connect(_save_settings)
	SignalManager.settings_loaded.connect(_load_settings)
