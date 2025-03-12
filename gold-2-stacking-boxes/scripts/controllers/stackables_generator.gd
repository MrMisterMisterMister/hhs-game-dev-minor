extends Node3D

@export var import_path: String
@export var export_path: String
var scenes: Dictionary = {}

func _ready() -> void:
	var path = "res://assets/" + import_path + "/"
	export_path = "res://scenes/stackables/" + export_path + "/"
	
	if not DirAccess.dir_exists_absolute(path):
		print_debug("Map doesn't exist:", path)
		return
	
	var files = DirAccess.get_files_at(path)
	
	if files:
		for file in files:
			if file.ends_with(".gltf"):
				scenes[file.get_basename()] = load(path + file)

	# Adding a small delay to ensure resources are properly loaded
	await get_tree().process_frame  # Wait for the next frame to ensure assets are loaded

	for scene_name in scenes:
		var food_instance = scenes[scene_name].instantiate()
		var food_mesh = food_instance.get_child(0) as MeshInstance3D
		
		## Needs to be changed based on stackable
		var new_mesh = MeshInstance3D.new()
		var new_name = scene_name.replace("FoodIngredient", "").replace("Food", "").replace("_", "")
		new_mesh.mesh = food_mesh.mesh
		new_mesh.name = new_name + "Mesh"
		
		var rigidbody = RigidBody3D.new()
		var rigidbody_name = new_name
		rigidbody.name = rigidbody_name
		rigidbody.add_to_group("stackable", true)
		
		rigidbody.add_child(new_mesh)
		new_mesh.owner = rigidbody
		add_child(rigidbody)

		await get_tree().process_frame  # Give time for node initialization

		add_collision_shape(new_mesh, rigidbody)
		save_food_scene(rigidbody_name, rigidbody)

		remove_child(rigidbody)
		rigidbody.queue_free()


func add_collision_shape(mesh: MeshInstance3D, parent: RigidBody3D):
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = mesh.mesh.create_convex_shape(false, true)
	collision_shape.name = "CollisionShape3D"
	parent.add_child(collision_shape)
	collision_shape.owner = parent


func save_food_scene(scene_name: String, root_node: Node3D) -> void:
	var packed_scene = PackedScene.new()
	root_node.owner = root_node
	
	for child in root_node.get_children():
		child.owner = root_node

	if packed_scene.pack(root_node) == OK:
		if not DirAccess.dir_exists_absolute(export_path):
			DirAccess.make_dir_recursive_absolute(export_path)
		
		var file_path = export_path + scene_name + ".tscn"
		var result = ResourceSaver.save(packed_scene, file_path)

		if result == OK:
			print("Exported stackable scene: ", file_path)
		else:
			print("Failed to export: ", scene_name)
