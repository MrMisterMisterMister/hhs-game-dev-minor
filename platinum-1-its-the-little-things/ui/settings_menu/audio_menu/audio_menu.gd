extends Control

var config_path: String = "user://settings.cfg"
var config_name: String = "audio"
var audio_busses: Dictionary[String, float]

@onready var audio_slider: PackedScene = preload("uid://bokru7b8utkpx")


func _ready() -> void:
	for index in range(AudioServer.get_bus_count()):
		var bus_name = AudioServer.get_bus_name(index)
		audio_busses[bus_name] = AudioServer.get_bus_volume_linear(index) * 100
	
	load_settings()


func _load_audio_busses() -> void:
	for child in get_children():
		child.queue_free()
	
	for audio_bus in audio_busses:
		var instance: AudioSlider = audio_slider.instantiate()
		add_child(instance)
		
		instance.label.text = audio_bus
		instance.slider.value = audio_busses[audio_bus]
		
		instance.slider.value_changed.connect(_volume_changed.bind(audio_bus))


func _volume_changed(value: float, bus_name: String) -> void:
	_set_volume(bus_name, value)
	_save_settings()


## Set volume for a specific bus (using percentage)
func _set_volume(bus_name: String, volume: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return
	
	# Convert from percentage to dB
	# Note: 0.0 percent = -80 dB (silent), 1.0 percent = 0 dB (max)
	if audio_busses: audio_busses[bus_name] = volume
	volume = linear_to_db(clampf(volume, 0.0, 100.0) / 100)
	AudioServer.set_bus_volume_db(bus_idx, volume)


func _save_settings() -> void:
	var config = ConfigFile.new()
	config.load(config_path) # Load existing settings
	
	for audio_bus_name: String in audio_busses:
		config.set_value(config_name, audio_bus_name, audio_busses[audio_bus_name])
	
	config.save(config_path)


func load_settings() -> void:
	var config = ConfigFile.new()
	
	if config.load(config_path) == OK and config.has_section(config_name):
		# Replace audio setttings with user's saved preferences
		for audio_bus_name in config.get_section_keys(config_name):
			var saved_volume = config.get_value(config_name, audio_bus_name)
			audio_busses[audio_bus_name] = saved_volume
			
			_set_volume(audio_bus_name, saved_volume)

	_load_audio_busses()
