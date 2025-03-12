extends Node3D

@export_group("Main")
@export var spawner: Node3D
@export var stack_tracker: Node3D
@export var camera_controller: Node3D
@export_group("Offsets")
@export var camera_offset: float = 1.0
@export var stack_tracker_offset: float = 1.0
@export_group("RayScale")
@export var ray_x_scale: float = 110.0
@export var ray_y_scale: float = 5.0
@export var ray_z_scale: float = 110.0


func _ready() -> void:
	camera_controller.global_position.y = spawner.global_position.y + camera_offset
	camera_controller.camera.rotation.x = deg_to_rad(-90)
	
	stack_tracker.global_position.y = spawner.global_position.y - stack_tracker_offset
	stack_tracker.scale = Vector3(ray_x_scale, ray_y_scale, ray_z_scale)
	
	spawner.spawn_position = get_spawn_position()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_stackable"):
		spawner.drop_stackable()


func _process(delta: float) -> void:
	spawner.spawn_position = get_spawn_position()
	
	if stack_tracker.global_position.y > spawner.global_position.y:
		spawner.global_position.y = lerp(
				spawner.global_position.y, 
				stack_tracker.global_position.y + stack_tracker_offset, 
				0.1)
		
		camera_controller.global_position.y = lerp(
				spawner.global_position.y, 
				spawner.global_position.y + camera_offset, 
				0.1)


func get_spawn_position():
	var mouse_position = camera_controller.get_mouse_position()
	var from = camera_controller.camera.project_ray_origin(mouse_position)
	var to = camera_controller.camera.project_ray_normal(mouse_position) * camera_controller.camera_follow_distance
	
	return from + to


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("stackable"):
		SignalManager.game_over.emit()
