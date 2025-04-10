extends Node


func change_scene(scene_path: String) -> void:
	for child in get_children():
		child.queue_free()
	
	add_scene(scene_path)


func add_scene(scene_path: String) -> void:
	var scene_resource: PackedScene = load(scene_path)
	
	if not scene_resource:
		push_error("Error: Could not load scene at path: ", scene_path)
		return
	
	var scene: Node = scene_resource.instantiate()
	
	await get_tree().process_frame
	
	if not scene:
		push_error("Error: Could not instantiate scene at path: ", scene_path)
		return
	
	add_child(scene)
