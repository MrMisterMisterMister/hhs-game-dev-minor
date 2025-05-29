extends CharacterBody2D

@export var speed: float = 80.0
@export var should_chase: bool = true
@export var funky_chase: bool = true
@export var path_update_interval: float = 0.2
@export var wave_frequency: float = 3.0 # how frequent the waves happen
@export var wave_amplitude: float = 3.0 # how intense the waves are
@export var rotation_speed: float = 6.0

var _time_passed: float = 0.0 # used for sine wave movement

var _last_path_update: float = 0.0
var _current_direction: Vector2 = Vector2.ZERO
var _target_rotation: float = 0.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	if not nav.velocity_computed.is_connected(_on_velocity_computed):
		nav.velocity_computed.connect(_on_velocity_computed)


func _physics_process(delta: float) -> void:
	if not should_chase: 
		return

	if funky_chase: 
		chase_but_funky(delta)
	else: 
		chase(delta)

	# Rotate toward movement direction
	if velocity.length() > 0.1:
		_target_rotation = velocity.angle()
		rotation = lerp_angle(rotation, _target_rotation, rotation_speed * delta)

	move_and_slide()


func _move_towards_target() -> void:
	var next_pos = nav.get_next_path_position()
	_current_direction = (next_pos - global_position).normalized()
	nav.set_velocity(_current_direction * speed)


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

	var perpendicular = Vector2(-_current_direction.y, _current_direction.x)
	var wave_offset = perpendicular * sin(_time_passed * wave_frequency) * wave_amplitude

	var funky_direction = (_current_direction * speed) + (wave_offset * speed * 0.3)
	nav.set_velocity(funky_direction)
