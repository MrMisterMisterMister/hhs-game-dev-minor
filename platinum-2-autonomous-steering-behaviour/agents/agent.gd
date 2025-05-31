extends CharacterBody2D

@export var chase_speed: float = 100.0
@export var flee_speed: float = 500.0
@export var should_chase: bool = true
@export var should_flee: bool = true
@export var funky_chase: bool = true
@export var path_update_interval: float = 0.2
@export var wave_frequency: float = 6.0
@export var wave_amplitude: float = 3.0
@export var rotation_speed: float = 6.0
@export var chase_distance: float = 30.0
@export var flee_distance: float = 500.0

var _time_passed: float = 0.0
var _chasing: bool = true
var _fleeing: bool = false
var _last_path_update: float = 0.0
var _current_direction: Vector2 = Vector2.ZERO
var _target_rotation: float = 0.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var flee_timer: Timer = $FleeTimer


func _ready() -> void:
	if not nav.velocity_computed.is_connected(_on_velocity_computed):
		nav.velocity_computed.connect(_on_velocity_computed)


func _physics_process(delta: float) -> void:
	if not should_chase:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var distance_to_mouse: float = global_position.distance_to(mouse_pos)

	if _chasing and distance_to_mouse <= chase_distance and should_flee:
		flee_timer.start()
		_chasing = false
		_fleeing = true

	elif _fleeing and distance_to_mouse >= flee_distance:
		flee_timer.stop()
		_chasing = true
		_fleeing = false

	if _chasing:
		if funky_chase:
			chase_but_funky(delta)
		else: 
			chase(delta)
	elif _fleeing:
		flee(delta)

	# Rotate towards target position
	if not is_zero_approx(velocity.length()):
		_target_rotation = velocity.angle()
		rotation = lerp_angle(rotation, _target_rotation, rotation_speed * delta)

	move_and_slide()


func _move_towards_target() -> void:
	var next_pos: Vector2 = nav.get_next_path_position()
	_current_direction = (next_pos - global_position).normalized()
	nav.set_velocity(_current_direction * chase_speed)


func _flee_from_target() -> void:
	var next_pos: Vector2 = nav.get_next_path_position()
	_current_direction = (next_pos - global_position).normalized()
	nav.set_velocity(_current_direction * flee_speed)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func chase(delta: float) -> void:
	if _last_path_update >= path_update_interval:
		nav.target_position = get_global_mouse_position()
		_last_path_update = 0.0
	else:
		_last_path_update += delta

	_move_towards_target()


func chase_but_funky(delta: float) -> void:
	_time_passed += delta
	if _last_path_update >= path_update_interval:
		nav.target_position = get_global_mouse_position()
		_last_path_update = 0.0
	else:
		_last_path_update += delta

	var next_pos = nav.get_next_path_position()
	_current_direction = (next_pos - global_position).normalized()

	var perpendicular: Vector2 = Vector2(-_current_direction.y, _current_direction.x)
	var wave_offset: Vector2 = perpendicular * sin(_time_passed * wave_frequency) * wave_amplitude
	var funky_direction: Vector2 = (_current_direction * chase_speed) + (wave_offset * chase_speed * 0.3)

	nav.set_velocity(funky_direction)


func flee(delta: float) -> void:
	if _last_path_update >= path_update_interval:
		var flee_direction: Vector2 = (global_position - get_global_mouse_position()).normalized()
		nav.target_position = global_position + flee_direction * flee_distance
		_last_path_update = 0.0
	else:
		_last_path_update += delta

	_flee_from_target()


func _on_flee_timer_timeout() -> void:
	_fleeing = false
	_chasing = true
