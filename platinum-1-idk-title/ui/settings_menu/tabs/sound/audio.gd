extends VBoxContainer

var audio_busses: Array[String]


func _ready() -> void:
	for index in range(AudioServer.get_bus_count()):
		audio_busses.append(AudioServer.get_bus_name(index))
	
	_load_sliders()

func _load_sliders() -> void:
	_add_separator()
	
	for bus_name in audio_busses:
		var slider = load("uid://cgjnxwufgrh74").instantiate()
		var label: Label = slider.get_node("Label")
		var h_slider: HSlider = slider.get_node("HSlider")
	
		label.text = bus_name
		
		h_slider.value_changed.connect(_on_slider_value_changed.bind(bus_name))
		
		h_slider.value =  100
		
		add_child(slider)
		
	_add_separator()


func _on_slider_value_changed(value: float, bus_name: String) -> void:
	AudioManager.set_volume_percent(bus_name, value)


func _add_separator():
	var h_separator = HSeparator.new()
	h_separator.add_theme_constant_override("separation", 50)
	h_separator.add_theme_stylebox_override("separator", StyleBoxEmpty.new())
	
	add_child(h_separator)
