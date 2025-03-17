extends Node

var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

var music_player: AudioStreamPlayer
var current_music: String = ""

var sfx_players: Array[AudioStreamPlayer] = []
var sfx_pool_size: int = 16

var sounds: Dictionary = {}


func _ready() -> void:
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	
	# Setup music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Setup SFX players pool
	for i in range(sfx_pool_size):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		player.finished.connect(_on_sfx_finished.bind(player))
		player.autoplay = false
		add_child(player)
		sfx_players.append(player)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

# Get the sfx player that is currently avaialable
func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	
	# If all players are in use, use the first one (oldest)
	print("WARNING: All SFX players are in use. Reusing oldest player.")
	return sfx_players[0]


func _on_sfx_finished(player: AudioStreamPlayer) -> void:
	# Reset player when finished
	player.stream = null


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


## Preload a sound effect
func preload_sound(sound_name: String, path: String) -> void:
	if not sounds.has(sound_name):
		var stream = load(path)
		if stream:
			sounds[sound_name] = stream


## Play a sound effect
func play_sfx(sound_path_or_name, volume_db: float = 0.0, pitch_scale: float = 1.0) -> AudioStreamPlayer:
	var stream
	
	# Check if the sound is a preloaded name or a path
	if sounds.has(sound_path_or_name):
		stream = sounds[sound_path_or_name]
	else:
		stream = load(sound_path_or_name)
	
	if stream:
		var player = _get_available_sfx_player()
		player.stream = stream
		player.volume_db = volume_db
		player.pitch_scale = pitch_scale
		player.play()
		return player
	
	print("ERROR: Could not play sound: ", sound_path_or_name)
	return null


func play_music(music_path: String, volume_db: float = 0.0, crossfade_duration: float = 1.0) -> void:
	# Don't restart if it's already playing the same music
	if current_music == music_path and music_player.playing:
		return
	
	current_music = music_path
	var stream = load(music_path)
	
	if stream:
		music_player.stop()
		music_player.stream = stream
		music_player.volume_db = volume_db
		music_player.play()
	else:
		push_error("Could not play music: ", music_path)


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
