class_name AspiringDragon
extends CharacterBody3D

enum Type {
	WATER,
	EARTH,
	FIRE,
	AIR,
}

@export var wander_radius: float = 100.0
@export var min_travel_distance: float = 20.0
@export var movement_speed: float = 6.0
@export var stuck_threshold: float = 2.0
@export var stuck_interval: float = 1.0
@export var rotation_speed: float = 6.0
@export var color: Color = Color.RED
@export var type: Type = Type.FIRE

var _can_move: bool = false
var _last_position: Vector3
var _stuck_timer: float = 0.0

@onready var spotlight_shape: CollisionShape3D = %SpotlightShape
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var mesh: MeshInstance3D = $MeshInstance3D


func _ready():
	var material: Material = mesh.get_active_material(0)
	material.set("albedo_color", color)

	if not nav.velocity_computed.is_connected(_on_velocity_computed):
		nav.velocity_computed.connect(_on_velocity_computed, CONNECT_DEFERRED)

	if not nav.navigation_finished.is_connected(_on_target_reached):
		nav.navigation_finished.connect(_on_target_reached)

	_last_position = global_position
	_set_new_valid_destination()


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	_cast_ray()
	if _stuck_timer >= stuck_interval:
		_check_if_stuck()
	else:
		_stuck_timer += delta

	if not _can_move or nav.is_navigation_finished():
		move_and_slide()
		return

	var next_path_pos: Vector3 = nav.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_path_pos)

	velocity = direction * movement_speed
	nav.set_velocity(direction * movement_speed)

	 # Calculate the angle to the target direction
	var target_angle: float = atan2(-direction.x, -direction.z)
	# Lerp the angle to smoothly rotate towards the target direction
	rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)


	move_and_slide()


func start_moving() -> void:
	_can_move = true


func stop_moving() -> void:
	_can_move = false


func _check_if_stuck() -> void:
	if not _last_position:
		_last_position = global_position
		return

	var distance_moved: float = global_position.distance_to(_last_position)

	if distance_moved < stuck_threshold:
		#print(name + " is stuck! Finding new path...")
		_set_new_valid_destination()

	_last_position = global_position
	_stuck_timer = 0.0


func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity


func _set_new_valid_destination():
	var max_attempts: int = 10

	for attempt in max_attempts:
		var destination: Vector3 = _get_random_navigable_position(wander_radius)
		if global_position.distance_to(destination) >= min_travel_distance:
			nav.target_position = destination
			return

	# Fallback if no valid position found
	nav.target_position = _get_random_navigable_position(wander_radius)


func _get_random_navigable_position(radius: float) -> Vector3:
	var random_direction: Vector3 = Vector3(
		randf_range(-1.0, 1.0),
		0,
		randf_range(-1.0, 1.0)
	).normalized()

	var random_distance: float = randf_range(min_travel_distance, radius)
	var target_position: Vector3 = global_position + random_direction * random_distance

	return NavigationServer3D.map_get_closest_point(
		get_world_3d().navigation_map,
		target_position
	)


func _on_target_reached() -> void:
	_set_new_valid_destination()


func _cast_ray() -> void:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	# Create transform that matches the dragon's facing direction
	var shape_transform = Transform3D()
	shape_transform.origin = mesh.global_position
	shape_transform.basis = mesh.global_transform.basis

	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = spotlight_shape.shape
	query.transform = shape_transform
	query.collision_mask = collision_mask

	var results = space_state.intersect_shape(query)

	for result in results:
		if result.collider is Player:
			var player: Player = result.collider

			# Raycast from dragon to player to check visibility
			var from = mesh.global_position + Vector3.UP * 0.1
			var to = player.global_position + Vector3.UP * 0.1
			
			var ray_query := PhysicsRayQueryParameters3D.create(from, to)
			ray_query.collision_mask = query.collision_mask

			var ray_result = space_state.intersect_ray(ray_query)

			# Check if the ray hits the player directly
			if ray_result and ray_result.collider == player:
				var message: String = Type.keys()[type].capitalize() + " dragon has eaten you."
				print(message)
				var hud: Hud = get_tree().get_first_node_in_group("hud")
				if hud: hud.game_ended(hud.GameType.LOST, message, color)
				return
