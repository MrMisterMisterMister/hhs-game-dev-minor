extends RemoteTransform3D

@export var lerp_weight: float
@export var camera_position: Node3D


func _process(delta: float) -> void:
	position = lerp(position, camera_position.position, delta * lerp_weight)
