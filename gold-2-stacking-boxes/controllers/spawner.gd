class_name Spawner
extends Node3D

@export_dir var path_to_stackables: String

var spawn_position: Vector3 = Vector3.ZERO

var _stackables: Array[PackedScene]
var _current_stackable: RigidBody3D
var _stackable_spawned: bool = false

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	_load_stackables()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_stackable"):
		_drop_stackable()


func _process(_delta: float) -> void:
	if not _current_stackable and spawn_timer.is_stopped():
		spawn_timer.start()
	
	if _current_stackable and _stackable_spawned:
		_current_stackable.global_position = spawn_position


func _spawn_stackable() -> void:
	if _stackable_spawned:
		return
	
	if _stackables.is_empty():
		return
	
	_current_stackable = _stackables.pick_random().instantiate()
	_current_stackable.freeze = true
	_stackable_spawned = true
	get_tree().get_first_node_in_group("stackables_counter").add_child(_current_stackable)
	print("Stackable: ", _current_stackable.name, ", Group: ", _current_stackable.get_groups()[0], ", Layer 1: ", _current_stackable.get_collision_layer_value(1) )


func _drop_stackable() -> void:
	if not _stackable_spawned:
		return
	
	_current_stackable.freeze = false
	_stackable_spawned = false
	spawn_timer.start()


func set_spawn_position(spawn_pos: Vector3) -> void:
	spawn_position = spawn_pos


func _load_stackables() -> void:
	assert(DirAccess.dir_exists_absolute(path_to_stackables), "Directory doesn't exist")
	
	var files = DirAccess.get_files_at(path_to_stackables)
	print("Found files: " + str(files))
	
	if files.is_empty():
		return
	
	for file in files:
		if file.ends_with(".remap"):
			file = file.substr(0, file.length() - 6)  # Remove .remap
		
		if file.ends_with(".tscn"):
			var resource_path = path_to_stackables + "/" + file
			var scene = load(resource_path)
			
			if scene:
				_stackables.append(scene)
				print("Successfully loaded: " + file)
			else:
				print_debug("Failed to load: " + resource_path)
	
	print("Total stackables loaded: " + str(_stackables.size()))


func _on_spawn_timer_timeout() -> void:
	_spawn_stackable()
