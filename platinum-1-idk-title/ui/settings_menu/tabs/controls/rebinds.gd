extends Control


var custom_actions: Array[String]
var rebind_buttons: Dictionary
var currently_rebinding: String
var waiting_for_input: bool

func _ready() -> void:
	var all_actions = InputMap.get_actions()
	
	for action in all_actions:
		if action.begins_with("ui"):
			continue
		
		custom_actions.append(action)

	_load_rebinds()

func _load_rebinds():
	_add_separator()
	
	for action in custom_actions:
		var events = InputMap.action_get_events(action)
		var rebind_item_instance = load("uid://cer3rjq3uh0df").instantiate()
		var label: Label = rebind_item_instance.get_node("Label")
		var button: Button = rebind_item_instance.get_node("Button")
		
		rebind_buttons[action] = button
		label.text = action.capitalize()
		
		if not events.size() > 0:
			button.text = "Not Set"
		elif events[0] is InputEventKey:
			button.text = OS.get_keycode_string(events[0].physical_keycode)
		elif events[0] is InputEventJoypadButton:
			button.text = "Joypad Button " + str(events[0].button_index)
		elif events[0] is InputEventJoypadMotion:
			var axis_name = "Axis " + str(events[0].axis)
			var direction = " +"
			if events[0].axis_value < 0:
				direction = " -"
			button.text = "Joypad " + axis_name + direction
		elif events[0] is InputEventMouseButton:
			match events[0].button_index:
				MOUSE_BUTTON_LEFT: button.text = "Left Mouse Button"
				MOUSE_BUTTON_RIGHT: button.text = "Right Mouse Button"
				MOUSE_BUTTON_MIDDLE: button.text = "Middle Mouse Button"
				MOUSE_BUTTON_WHEEL_UP: button.text = "Mouse Wheel Up"
				MOUSE_BUTTON_WHEEL_DOWN: button.text = "Mouse Wheel Down"
				_: button.text = "Mouse Button " + str(events[0].button_index)
		
		button.toggled.connect(_on_rebind_button_toggle.bind(action, button))
		
		add_child(rebind_item_instance)
	
	_add_separator()


func _add_separator():
	var h_separator = HSeparator.new()
	h_separator.add_theme_constant_override("separation", 50)
	h_separator.add_theme_stylebox_override("separator", StyleBoxEmpty.new())
	
	add_child(h_separator)


func _on_rebind_button_toggle(toggle_on: bool, action: String, button: Button) -> void:
	currently_rebinding = action
	waiting_for_input = true
	button.text = "Listening for input"
	
	for act in rebind_buttons:
		if act == action: 
			continue
		rebind_buttons[act].toggle_mode = false
	
	set_process_input(toggle_on)


func _input(event: InputEvent) -> void:
	if not waiting_for_input or currently_rebinding.is_empty():
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		_set_new_binding(event)
	elif event is InputEventJoypadButton and event.pressed:
		_set_new_binding(event)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
		# Normalize axis value to either -1.0 or 1.0
		var normalized_event = event.duplicate()
		normalized_event.axis_value = 1.0 if event.axis_value > 0 else -1.0
		_set_new_binding(normalized_event)
	elif event is InputEventMouseButton and event.pressed:
		_set_new_binding(event)


func _set_new_binding(event: InputEvent) -> void:
	InputMap.action_erase_events(currently_rebinding) # Clear existing bindings
	InputMap.action_add_event(currently_rebinding, event) # Add new binding
	
	set_process_input(false)
	
	# Reload to update button text
	_clear_children()
	_load_rebinds()


func _clear_children():
	for child in get_children():
		child.queue_free()
