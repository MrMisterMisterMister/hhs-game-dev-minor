extends Node3D

@export var path_to_stackables: String

var stackables: Array[PackedScene]
var stackable: Node3D
var stackable_spawned: bool = false
var spawn_position: Vector3

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	var path = "res://scenes/stackables/" + path_to_stackables + "/"
	print_debug("Looking for stackables at: " + path)
	
	if not DirAccess.dir_exists_absolute(path):
		print_debug("Map doesn't exist:", path)
		return
	
	var files = DirAccess.get_files_at(path)
	print_debug("Found files: " + str(files))
	
	if files.is_empty():
		return

	for file in files:
		
		if file.ends_with(".remap"):
			file = file.substr(0, file.length() - 6)  # Remove .remap
		
		if file.ends_with(".tscn"):
			var resource_path = path + file
			print_debug("Trying to load: " + resource_path)
			
			var scene = load(resource_path)
			if scene:
				stackables.append(scene)
				print_debug("Successfully loaded: " + file)
			else:
				print_debug("Failed to load: " + resource_path)
	
	print_debug("Total stackables loaded: " + str(stackables.size()))


func _process(delta: float) -> void:
	if not stackable and spawn_timer.is_stopped():
		spawn_timer.start()
	
	if stackable and stackable_spawned:
		stackable.global_position = spawn_position


func spawn_stackable() -> void:
	if stackable_spawned:
		return
	
	if stackables.is_empty():
		return
	
	stackable = stackables.pick_random().instantiate()
	stackable.freeze = true
	stackable_spawned = true
	get_tree().current_scene.add_child(stackable)
	print("Stackable: ", stackable.name, ", Group: ", stackable.get_groups()[0], ", Layer 1: ", stackable.get_collision_layer_value(1) )


func drop_stackable() -> void:
	if not stackable:
		return
	
	stackable.freeze = false
	stackable_spawned = false
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	spawn_stackable()
