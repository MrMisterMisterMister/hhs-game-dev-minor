class_name CameraController
extends Node3D

@export_category("Camera Settings")
@export var camera_smoothing: float = 5.0
@export var camera_height_offset: float = 5.0

@export_category("Edge Scrolling")
@export var edge_offset: float = 4.0 # Maximum screen offset
@export var edge_scroll_speed: float = 3.0 # Speed of the edge movement
@export var edge_threshold: float = 100.0 # Threshold before camera starts moving

var _camera_offset: Vector3
var _current_highest: float
var _highest_height: float

@onready var camera: Camera3D = $Camera3D


func _process(delta: float) -> void:
	_handle_edge_scrolling(delta)
	_update_camera_position(delta)
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _find_highest_stackable() -> float:
	var highest_point: float = 0.0
	var space_state = get_world_3d().direct_space_state
	
	# Create a grid of raycast points (5x5 in this example)
	var raycast_points = []
	var grid_size = 5
	var spacing = 0.1
	
	for x in range(grid_size):
		for z in range(grid_size):
			var offset = Vector3(spacing, 0, spacing)
			raycast_points.append(global_position + offset)
	
	# Cast rays from each point
	for point in raycast_points:
		var from: Vector3 = point + Vector3.UP * 50  # Start above the point
		var to: Vector3 = point + Vector3.DOWN * 100  # Cast downward
		
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		var collider = result.get("collider")
		if not collider.is_in_group("stackable"):
			return highest_point
		if collider.is_freeze_enabled():
			return highest_point
		if collider.linear_velocity.length() > 0.1:
			return highest_point
		
		if result:
			highest_point = max(highest_point, result.position.y)
		
		_highest_height = highest_point
	
	return highest_point


func _update_camera_position(delta: float) -> void:
	# Calculate target position (maintain current height)
	if _current_highest < _find_highest_stackable() + camera_height_offset:
		_current_highest = _find_highest_stackable() + camera_height_offset
	
	var height: float = global_position.y if global_position.y > _current_highest else _current_highest
	
	var target_position = Vector3(
		global_position.x + _camera_offset.x,
		height,
		global_position.z + _camera_offset.z
	)
	
	camera.global_position = lerp(
		camera.global_position,
		target_position,
		delta * camera_smoothing)


func _handle_edge_scrolling(delta: float) -> void:
	var scroll_vec: Vector2 = Vector2.ZERO
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	
	# Check if mouse is near screen edges.
	# The close to the edge, the stronger the scroll.
	if mouse_pos.x < edge_threshold: # Left edge
		scroll_vec.x = -1.0 * (1.0 - (mouse_pos.x / edge_threshold))
	elif mouse_pos.x > screen_size.x - edge_threshold: # Right edge
		scroll_vec.x = 1.0 * (1.0 - ((screen_size.x - mouse_pos.x) / edge_threshold))
	
	if mouse_pos.y < edge_threshold: # Top edge
		scroll_vec.y = -1.0 * (1.0 - (mouse_pos.y / edge_threshold))
	elif mouse_pos.y > screen_size.y - edge_threshold: # Bottom edge
		scroll_vec.y = 1.0 * (1.0 - ((screen_size.y - mouse_pos.y) / edge_threshold))
	
	scroll_vec = scroll_vec.normalized() # Normalize diagonal speed
	
	# Apply scrolling
	_camera_offset.x += scroll_vec.x * edge_scroll_speed * delta
	_camera_offset.z += scroll_vec.y * edge_scroll_speed * delta
	
	# Limit movement
	_camera_offset.x = clamp(_camera_offset.x, -edge_offset, edge_offset)
	_camera_offset.z = clamp(_camera_offset.z, -edge_offset, edge_offset)


func get_camera() -> Camera3D:
	return camera


func get_highest_height() -> float:
	return _highest_height
