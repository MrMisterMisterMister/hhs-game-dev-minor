extends Control

var config_path: String = "user://settings.cfg"
var config_name: String = "keybinds"

var custom_actions: Array[String]
var currently_rebinding: String
var waiting_for_input: bool

@onready var keybind_container: VBoxContainer = $VBoxContainer


func _load_keybind_items():
	for action in InputMap.get_actions():
		if action.begins_with("ui"): continue
		
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		var event: InputEvent = events[0]
		var keybind_item: KeybindItem = load("uid://pwl2v5l6nesn").instantiate()
		
		keybind_container.add_child(keybind_item)
		
		keybind_item.label.text = action.capitalize().replace("_", " ")
		
		if event is InputEventKey:
			keybind_item.keybind.text = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			keybind_item.keybind.text = str(event.button_index)
		else:
			keybind_item.keybind.text = "Unbound"
		
		keybind_item.keybind.toggled.connect(_on_keybind_button_toggle.bind(action, keybind_item.keybind))


func _on_keybind_button_toggle(toggle_on: bool, action: String, button: Button) -> void:
	currently_rebinding = action
	waiting_for_input = true
	button.text = "Listening for input"
	
	button.toggle_mode = false
	
	set_process_input(toggle_on)


func _input(event: InputEvent) -> void:
	if not waiting_for_input or currently_rebinding.is_empty():
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		_set_new_binding(event)
	elif event is InputEventMouseButton and event.pressed:
		_set_new_binding(event)


func _set_new_binding(event: InputEvent) -> void:
	InputMap.action_erase_events(currently_rebinding) # Clear existing bindings
	InputMap.action_add_event(currently_rebinding, event) # Add new binding
	
	set_process_input(false)
	
	# Reload to update button text
	_refresh()
	
	_save_settings()


func _refresh():
	for child in keybind_container.get_children():
		child.queue_free()
	
	_load_keybind_items()


func _save_settings():
	var config = ConfigFile.new()
	config.load(config_path) # Load existing settings
	
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue
	
		config.set_value(config_name, action, InputMap.action_get_events(action)[0])
	
	config.save(config_path)


func load_settings() -> void:
	InputMap.load_from_project_settings()
	var config = ConfigFile.new()
	
	if config.load(config_path) == OK and config.has_section(config_name):
		for action in config.get_section_keys(config_name):
			InputMap.action_erase_events(action)
			var event: InputEvent = config.get_value(config_name, action)
			InputMap.action_add_event(action, event)
	
	_refresh()
	_load_keybind_items()
