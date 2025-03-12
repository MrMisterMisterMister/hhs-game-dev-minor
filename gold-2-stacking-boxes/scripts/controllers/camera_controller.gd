extends Node3D

@export var camera: Camera3D
@export var camera_smoothing: float = 6.0
@export var camera_follow_distance: float = 2.0
@export var max_camera_distance: float = 2.0
@export var edge_scroll_speed: float = 3.0
@export var edge_threshold: float = 50.0

var target_camera_position: Vector3
var camera_offset: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	handle_edge_scrolling(get_mouse_position(), get_screen_size(), delta)
	
	# Calculate target position
	target_camera_position = Vector3(
		global_position.x + camera_offset.x,
		global_position.y + camera_follow_distance,
		global_position.z + camera_offset.z
	)
	
	# Smoothly move camera
	camera.global_position = camera.global_position.lerp(target_camera_position, delta * camera_smoothing)

func handle_edge_scrolling(mouse_pos: Vector2, screen_size: Vector2, delta: float) -> void:
	var scroll_vec = Vector2.ZERO
	
	# Check if mouse is near screen edges
	if mouse_pos.x < edge_threshold:
		scroll_vec.x = -1.0 * (1.0 - (mouse_pos.x / edge_threshold))
	elif mouse_pos.x > screen_size.x - edge_threshold:
		scroll_vec.x = 1.0 * (1.0 - ((screen_size.x - mouse_pos.x) / edge_threshold))
		
	if mouse_pos.y < edge_threshold:
		scroll_vec.y = -1.0 * (1.0 - (mouse_pos.y / edge_threshold))
	elif mouse_pos.y > screen_size.y - edge_threshold:
		scroll_vec.y = 1.0 * (1.0 - ((screen_size.y - mouse_pos.y) / edge_threshold))
	
	# Apply scrolling
	camera_offset.x += scroll_vec.x * edge_scroll_speed * delta
	camera_offset.z += scroll_vec.y * edge_scroll_speed * delta
	
	# Limit movement
	camera_offset.x = clamp(camera_offset.x, -max_camera_distance, max_camera_distance)
	camera_offset.z = clamp(camera_offset.z, -max_camera_distance, max_camera_distance)


func get_mouse_position():
	return get_viewport().get_mouse_position()


func get_screen_size():
	return get_viewport().get_visible_rect().size
