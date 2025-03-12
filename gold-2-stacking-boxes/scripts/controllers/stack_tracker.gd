extends RayCast3D

@export var min_linear_velocity: float = 0.1
@export var height_offset: float = 5.0

var highest_y: float = -INF
var stackable: Node3D


func _physics_process(_delta: float) -> void:
	if not is_colliding():
		return
	
	var collider = get_collider()
	
	if not collider.is_in_group("stackable"):
		return
	
	if collider.freeze:
		return
	
	if collider.linear_velocity.length() > min_linear_velocity:
		return
	
	var collision_point = get_collision_point()
	if collision_point.y > highest_y:
		highest_y = collision_point.y
		global_position.y = lerp(global_position.y, highest_y + height_offset, 0.1)
		print_debug("Updated highest y to: ", highest_y)
