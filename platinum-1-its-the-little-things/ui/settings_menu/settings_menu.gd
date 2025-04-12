extends Control

var settings: Array

@onready var display_menu_resource: PackedScene = preload("uid://e0apbka5i4ja")
@onready var keybinds_menu_resource: PackedScene = preload("uid://bkep2ge7c4t5q")
@onready var audio_menu_resource: PackedScene = preload("uid://4f042eku5w51")

@onready var display: TabBar = %Display
@onready var keybinds: TabBar = %Keybinds
@onready var audio: TabBar = %Audio


func _ready() -> void:
	var display_menu = display_menu_resource.instantiate()
	var keybinds_menu = keybinds_menu_resource.instantiate()
	var audio_menu = audio_menu_resource.instantiate()
	
	settings.append(display_menu)
	settings.append(keybinds_menu)
	settings.append(audio_menu)
	
	display.add_child(display_menu)
	keybinds.add_child(keybinds_menu)
	audio.add_child(audio_menu)
	
	_load_settings()


func _load_settings() -> void:
	for item in settings:
		print_debug("settings loaded:", item.name)
		if item.has_method("load_settings"):
			item.load_settings()
