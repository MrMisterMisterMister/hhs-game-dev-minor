extends CanvasLayer


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


func clear_ui() -> void:
	for child in get_children():
		child.queue_free()
