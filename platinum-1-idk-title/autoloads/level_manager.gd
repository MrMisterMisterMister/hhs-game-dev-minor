extends Node

var parent: Node
var levels: Array[String]
var current_level_id: int
var current_level_instance: Node3D


func _ready() -> void:
	_load_levels("res://levels/")
	
	SignalManager.level_changed.connect(change_level)


func _load_levels(path: String) -> void:
	var dir = DirAccess.open(path)
	
	if !dir:
		push_error("Error accessing levels directory: " + path)
		return
	
	dir.list_dir_begin()
	var level_path = dir.get_next()
	
	while level_path != "":
		if not dir.current_is_dir() and level_path.ends_with(".tscn"):
			levels.append(path + level_path)
			print("Found level at: ", path + level_path)
			
		level_path = dir.get_next()
	


func change_level(index: int) -> void:
	if not levels.get(index):
		push_error("Level with id ", index, " does not exists")
		return
	
	exit_level()
	
	var level = load(levels[index])
	if not level:
		push_error("Failed to load level: ", levels[index])
	
	current_level_id = index
	current_level_instance = level.instantiate()
	current_level_instance.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	parent.add_child(current_level_instance)


func exit_level() -> void:
	if current_level_instance:
		parent.remove_child(current_level_instance)
		current_level_instance.queue_free()
