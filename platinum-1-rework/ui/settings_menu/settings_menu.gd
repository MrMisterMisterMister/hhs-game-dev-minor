extends Control


var settings: Array

@onready var display_items: PackedScene = preload("uid://e0apbka5i4ja")
@onready var audio_items: PackedScene = preload("uid://4f042eku5w51")

@onready var display: TabBar = %Display
@onready var keybinds: TabBar = %Keybinds
@onready var audio: TabBar = %Audio


func _ready() -> void:
	var display_menu = display_items.instantiate()
	var audio_menu = audio_items.instantiate()
	
	settings.append(display_menu)
	settings.append(audio_menu)
	
	display.add_child(display_menu)
	audio.add_child(audio_menu)
	
	SignalManager.settings_loaded.connect(_load_settings)


func _load_settings() -> void:
	for item in settings:
		if item.has_method("load_settings"):
			item.load_settings
