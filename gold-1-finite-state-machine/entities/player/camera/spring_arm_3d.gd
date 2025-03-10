extends Node3D

@export var parent: CharacterBody3D
@export var mouse_sens: float = 0.005
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = PI/4

@onready var spring_arm: SpringArm3D = $SpringArm3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		get_parent().rotation.y -= event.relative.x * mouse_sens
		parent.get_node("Visuals").rotation.y += event.relative.x * mouse_sens

		rotation.x -= event.relative.y * mouse_sens
		rotation.x  = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
	
	if event.is_action_pressed("wheel_up"):
		spring_arm.spring_length -= 0.5
	if event.is_action_pressed("wheel_down"):
		spring_arm.spring_length += 0.5
	
	if event.is_action_pressed("toggle_mouse_capture"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
