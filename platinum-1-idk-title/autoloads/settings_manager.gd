extends Node

var fullscreen: bool
var borderless: bool
var v_sync: bool
var resolution: int

var display_settings: Dictionary
var sound_settings: Dictionary
var controls_settings: Dictionary

var default_settings: Resource = preload("uid://c1jmxolxpbgq6")
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
		fullscreen = config.get_value("display", "fullscreen")
		borderless = config.get_value("display", "borderless")
		v_sync = config.get_value("display", "v-sync")
		resolution = config.get_value("display", "resolution")
	else:
		_load_defaut_settings()
	
	SignalManager.display_settings_loaded.emit()


func _load_defaut_settings() -> void:
	fullscreen = default_settings.DEFAULT_FULLSCREEN
	borderless = default_settings.DEFAULT_BORDERLESS
	v_sync = default_settings.DEFAULT_V_SYNC
	resolution = default_settings.DEFAULT_RESOLUTION


func _export_settings() -> Dictionary:
	return {
		"display" : _export_display_settings(),
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


func _connect_signals() -> void:
	SignalManager.fullscreen_changed.connect(_update_fullscreen)
	SignalManager.borderless_changed.connect(_update_borderless)
	SignalManager.v_sync_changed.connect(_update_v_sync)
	SignalManager.resolution_changed.connect(_update_resolution)
	
	SignalManager.settings_saved.connect(_save_settings)
	SignalManager.settings_loaded.connect(_load_settings)
