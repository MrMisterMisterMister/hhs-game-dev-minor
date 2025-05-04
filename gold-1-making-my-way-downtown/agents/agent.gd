class_name Agent
extends CharacterBody3D

enum Type {
	NORMAL,
	PATROLLER
}

@export var speed = 5.0
@export var type: Type
@export var tolerance: float = 1.0
@export var rotation_speed: float = 6.0

var selected: bool = false:
	set(value):
		selected = value
		label.visible = value

var destination: Vector3

var _current_direction: Vector3

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var label: Label3D = $Label3D


func _physics_process(delta: float) -> void:
	velocity.y += get_gravity().y * delta

	if destination:
		nav.target_position = destination
		_current_direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = _current_direction * speed

	if global_position.distance_to(destination) < tolerance:
		velocity = Vector3.ZERO

	if _current_direction.length() > 0:
		var target_rotation: Basis = Basis.looking_at(_current_direction, Vector3.UP)
		transform.basis = transform.basis.slerp(target_rotation, rotation_speed * delta)

	move_and_slide()


static func type_to_string(t: Type) -> String:
	return Type.keys()[t]
