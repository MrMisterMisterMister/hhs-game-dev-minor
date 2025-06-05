@tool
class_name AspiringDragon
extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var wander_radius: float = 500.0
@export var min_travel_distance: float = 100.0
@export var movement_speed: float = 8.0

var _current_destination: Vector3
var _previous_position: Vector3
var _can_move: bool


func _ready():
	_previous_position = global_position
	set_new_valid_destination()
	nav.navigation_finished.connect(_on_navigation_finished)


func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += delta * get_gravity().y

	if not _can_move:
		return

	if nav.is_navigation_finished():
		return

	var next_path_pos = nav.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)

	velocity.x = direction.x * movement_speed
	velocity.z = direction.z * movement_speed

	move_and_slide()


func start_moving() -> void:
	_can_move = true


func _on_navigation_finished():
	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
	set_new_valid_destination()


func set_new_valid_destination():
	var attempt = 0
	var max_attempts = 10

	while attempt < max_attempts:
		var destination: Vector3 = get_random_navigable_position(wander_radius)

		# Ensure minimum travel distance
		if global_position.distance_to(destination) >= min_travel_distance:
			_current_destination = destination
			nav.target_position = _current_destination
			_previous_position = global_position
			return

		attempt += 1

	# If no valid position found after attempts, just pick any
	_current_destination = get_random_navigable_position(wander_radius)
	nav.target_position = _current_destination


func get_random_navigable_position(radius: float) -> Vector3:
	var random_direction = Vector3(
		randf_range(-1.0, 1.0),
		0,
		randf_range(-1.0, 1.0)
	).normalized()

	var random_distance: float = randf_range(min_travel_distance, radius)
	var target_position: Vector3 = global_position + (random_direction * random_distance)

	return NavigationServer3D.map_get_closest_point(
		get_world_3d().navigation_map,
		target_position
	)
