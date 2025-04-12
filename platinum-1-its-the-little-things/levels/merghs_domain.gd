extends Node3D

const CIPHER = preload("res://assets/audio/Cipher.mp3")

@onready var bg_music: AudioStreamPlayer = $BGMusic
@onready var world_environment: WorldEnvironment = $WorldEnvironment


func _ready() -> void:
	SignalManager.boss_defeated.connect(_on_mergh_defeated)


func _on_mergh_defeated() -> void:
	bg_music.stream = CIPHER
	bg_music.play()
	
	world_environment.environment.background_mode = Environment.BG_SKY
