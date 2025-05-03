extends CanvasLayer

var previous_ui: Control
var current_ui: Control
var prev_mouse_mode: Input.MouseMode
var ui_list: Dictionary[String, Control]

var paused: bool:
	set(value):
		paused = value
		get_tree().paused = value
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if value else prev_mouse_mode
		print("Prev Mouse Mode: ", prev_mouse_mode)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		handle_pause()


func change_ui(path: String, params: Dictionary = {}) -> void:
	clear_ui()
	
	add_ui(path, params)


func add_ui(path: String, params: Dictionary = {}) -> void:
	assert(ResourceLoader.exists(path), "path doesn't exist")
	
	var ui_resource: Resource = load(path)
	
	if not ui_resource:
		push_error("Error: Could not load UI scene at path: ", path)
		return  # Exit if the scene failed to load
	
	var ui_node: Node = ui_resource.instantiate()
	
	if not ui_node:
		push_error("Error: Could not load UI scene at path: ", path)
		return  # Exit if the scene failed to load
	
	if ui_node.has_method("setup"):
		ui_node.setup(params)
	
	add_child(ui_node)
	switch_ui(current_ui, ui_node)
	
	ui_list[ui_node.name] = ui_node


func switch_ui(prev_ui: Node, curr_ui: Node) -> void:
	previous_ui = prev_ui if prev_ui else null
	current_ui = curr_ui if curr_ui else null


func clear_ui() -> void:
	for ui in ui_list:
		ui_list[ui].visible = false
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	ui_list.clear()
	
	previous_ui = null
	current_ui = null


func show_ui(ui_name: String) -> void:
	if ui_name not in ui_list:
		printerr("'", ui_name, "'", " does not exist.")
		return
	
	var new_ui: Control = ui_list[ui_name]
	
	if current_ui != new_ui:
		switch_ui(current_ui, new_ui)
	
	new_ui.visible = true
	move_child(new_ui, get_child_count() - 1)


func handle_pause() -> void:
	if ui_list.has("GameOver"):
		return
	
	set_process(UI)
	
	if not paused:
		prev_mouse_mode = Input.mouse_mode
	
	var pause_menu_exists: bool = ui_list.has("PauseMenu")
	var pause_menu_visible: bool = pause_menu_exists and ui_list["PauseMenu"].visible
	
	if pause_menu_exists and current_ui == ui_list["PauseMenu"]:
		current_ui.visible = not current_ui.visible
		paused = current_ui.visible
	elif current_ui:
		current_ui.visible = false
		paused = pause_menu_visible
		switch_ui(current_ui, previous_ui)
