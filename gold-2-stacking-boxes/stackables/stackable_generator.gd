extends Node

@export_dir var import_path: String
@export_dir var export_path: String

var scenes: Dictionary = {}

func _ready() -> void:
	assert(DirAccess.dir_exists_absolute(import_path), "Map doesn't exist.")
	
	var files = DirAccess.get_files_at(import_path)
	
	if files:
		for file in files:
			if file.ends_with(".gltf"):
				scenes[file.get_basename()] = load(import_path + "/"+ file)
	
	await get_tree().process_frame  # Wait for assets to load
	
	for scene_name in scenes:
		await _process_food_scene(scene_name)


func _process_food_scene(scene_name: String) -> void:
	var food_instance = scenes[scene_name].instantiate()
	var food_mesh = food_instance.get_child(0) as MeshInstance3D
	
	var new_mesh = MeshInstance3D.new()
	var new_name = scene_name.replace("FoodIngredient", "").replace("Food", "").replace("_", "")
	new_mesh.mesh = food_mesh.mesh
	new_mesh.name = new_name + "Mesh"
	
	var rigidbody = RigidBody3D.new()
	rigidbody.name = new_name
	rigidbody.add_to_group("stackable", true)
	
	# Add mesh first
	rigidbody.add_child(new_mesh)
	new_mesh.owner = rigidbody
	
	# Add collision shape before adding to tree
	_add_collision_shape(new_mesh, rigidbody)
	
	# Add to tree and wait for proper initialization
	add_child(rigidbody)
	await get_tree().process_frame
	
	# Reset position after being in tree
	rigidbody.global_position = Vector3.ZERO
	
	# Save the scene
	_save_food_scene(new_name, rigidbody)
	
	# Cleanup
	remove_child(rigidbody)
	rigidbody.queue_free()


func _add_collision_shape(mesh: MeshInstance3D, parent: RigidBody3D) -> void:
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = mesh.mesh.create_convex_shape(false, true)
	collision_shape.name = "CollisionShape3D"
	parent.add_child(collision_shape)
	collision_shape.owner = parent


func _save_food_scene(scene_name: String, root_node: Node3D) -> void:
	var packed_scene = PackedScene.new()
	
	# Ensure all children have proper ownership
	for child in root_node.get_children():
		child.owner = root_node
	
	if packed_scene.pack(root_node) == OK:
		if not DirAccess.dir_exists_absolute(export_path):
			DirAccess.make_dir_recursive_absolute(export_path)
		
		var file_path = export_path + "/" + scene_name + ".tscn"
		var result = ResourceSaver.save(packed_scene, file_path)
	
		if result == OK:
			print("Exported stackable scene: ", file_path)
		else:
			print("Failed to export: ", scene_name)
