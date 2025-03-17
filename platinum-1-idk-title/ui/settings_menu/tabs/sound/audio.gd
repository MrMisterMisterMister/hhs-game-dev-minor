extends VBoxContainer

var audio_busses: Array[String]
var sliders: Dictionary


func _ready() -> void:
	for index in range(AudioServer.get_bus_count()):
		audio_busses.append(AudioServer.get_bus_name(index))
	
	_load_sliders()
	SignalManager.sound_settings_loaded.connect(_load_sound_settings)


func _load_sliders() -> void:
	for bus_name in audio_busses:
		var slider = load("uid://cgjnxwufgrh74").instantiate()
		var label: Label = slider.get_node("Label")
		var h_slider: HSlider = slider.get_node("HSlider")
		
		sliders[bus_name] = h_slider
		label.text = bus_name
		h_slider.value_changed.connect(_on_slider_value_changed.bind(bus_name))
		
		add_child(slider)


func _on_slider_value_changed(value: float, bus_name: String) -> void:
	AudioManager.set_volume_percent(bus_name, value)
	
	sliders[bus_name].set_value_no_signal(value)
	SignalManager.volume_changed.emit(bus_name, value)


func _load_sound_settings() -> void:
	var audio: Dictionary = SettingsManager.volume
	
	for bus_name in audio:
		_on_slider_value_changed(audio[bus_name], bus_name)
		print(bus_name, audio[bus_name])
