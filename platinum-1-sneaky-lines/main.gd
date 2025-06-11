extends Node3D

@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator
@onready var camera: FreeLookCamera = $Camera3D


func _ready() -> void:
	dungeon_generator.generate()


func _switch_camera() -> void:
	camera.current = true
