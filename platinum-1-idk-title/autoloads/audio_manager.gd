extends Node

var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

var music_player: AudioStreamPlayer
var current_music: String = ""

var sfx_players: Dictionary
var current_sfx: Dictionary

var sounds: Dictionary = {}


func _ready() -> void:
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	
	# Setup music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	process_mode = Node.PROCESS_MODE_ALWAYS


## Set volume for a specific bus (in dB)
func set_volume_db(bus_name: String, volume_db: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, volume_db)


## Get current volume for a specific bus (in dB)
func get_volume_db(bus_name: String) -> float:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		return AudioServer.get_bus_volume_db(bus_idx)
	return 0.0


## Set volume for a specific bus (in percentage, 0.0 to 1.0)
func set_volume_percent(bus_name: String, volume_percent: float) -> void:
	# Convert from percentage to dB
	# Note: 0.0 percent = -80 dB (silent), 1.0 percent = 0 dB (max)
	var volume_db = linear_to_db(clamp(volume_percent, 0, 100)/100)
	set_volume_db(bus_name, volume_db)


## Get current volume for a specific bus (in percentage, 0.0 to 1.0)
func get_volume_percent(bus_name: String) -> float:
	var volume_db = get_volume_db(bus_name)
	return db_to_linear(volume_db)


## Play music
func play_music(music_path: String) -> void:
	# Don't restart if it's already playing the same music
	if current_music == music_path and music_player.playing:
		return
	
	current_music = music_path
	var stream = load(music_path)
	
	if stream:
		music_player.stop()
		music_player.stream = stream
		music_player.play()
	else:
		push_error("Could not play music: ", music_path)


func play_sfx(sfx_path: String, from: String) -> void:
	for sfx in sfx_players:
		pass


func stop_music(fade_duration: float = 1.0) -> void:
	if music_player.playing:
		music_player.stop()
	
	current_music = ""


## Pause/resume music
func pause_music(paused: bool = true) -> void:
	music_player.stream_paused = paused


## Set music position (in seconds)
func set_music_position(position_seconds: float) -> void:
	if music_player.playing:
		music_player.seek(position_seconds)
