extends Node3D

const MAX_ARM_LENGTH = 15.0
const MIN_ARM_LENGTH = 0.0

@export_category("Camera")
@export var camera_reference: Camera3D
@export_range(MIN_ARM_LENGTH, MAX_ARM_LENGTH, 0.1) var camera_spring_length: float = 5.5
@export var camera_margin: float = -0.5
@export var camera_smoothness: float = 5.0

@export_category("Entity")
@export var entity_to_follow: Node3D
@export var horizontal_offset: float = 0.0
@export var vertical_offset: float = 1.5
@export var distance: float = 0.0
@export var min_visible_distance = 1.6

@export_category("Sensitity")
@export_range(0.001, 0.01, 0.0001) var horizontal_sensitivity: float = 0.005
@export_range(0.001, 0.01, 0.0001) var vertical_sensitivity: float = 0.005
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = PI/4

var visual : Node3D

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var remote_transform_3d: RemoteTransform3D = $RemoteTransform3D


func _ready():
	if not camera_reference:
		push_error("No Camera3D assigned")
	
	spring_arm_3d.spring_length = camera_spring_length
	spring_arm_3d.margin = camera_margin
	
	remote_transform_3d.remote_path = camera_reference.get_path()
	remote_transform_3d.lerp_weight = camera_smoothness
	
	visual = entity_to_follow.get_node("Visual")
	
	call_deferred("reparent", entity_to_follow)
	position = Vector3(horizontal_offset, vertical_offset, distance)


func _input(event):
	# Handle mouse rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if not entity_to_follow.move_state_machine:
			print("Entity ", entity_to_follow, " does not have a state machine")
			return
		
		var state = entity_to_follow.move_state_machine.current_state.name
		
		# This will allow the camera to rotate around player when idle or resting
		if state in ["Idle", "Rest", "Rise"]:
			entity_to_follow.rotation.y -= event.relative.x * horizontal_sensitivity
			visual.rotation.y += event.relative.x * horizontal_sensitivity
		else:
			entity_to_follow.rotation.y -= event.relative.x * horizontal_sensitivity
		
		rotation.x -= event.relative.y * vertical_sensitivity
		rotation.x  = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
	
	# Zoom in and out, and clam distance
	if event.is_action_pressed("zoom_in"):
		spring_arm_3d.spring_length -= 0.5
	if event.is_action_pressed("zoom_out"):
		spring_arm_3d.spring_length += 0.5
	spring_arm_3d.spring_length = clamp(spring_arm_3d.spring_length, MIN_ARM_LENGTH, MAX_ARM_LENGTH)
	
	# Toggle mouse mode
	if event.is_action_pressed("toggle_mouse_mode"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	# Calculate actual distance between camera and entity
	var camera_position = camera_reference.global_position
	var entity_position = entity_to_follow.global_position
	var actual_distance = camera_position.distance_to(entity_position)
	
	# Toggle visibility based on actual distance
	entity_to_follow.visible = actual_distance > min_visible_distance
