extends Agent

var patrol_points: Array[Vector3]
var current_point: int = 0


func _physics_process(delta: float) -> void:
	if not destination:
		return

	if global_position.distance_to(destination) < 1:
		current_point = int(current_point == 0)
		destination = patrol_points[current_point]

	super(delta)


func set_patrol_points(points: Array[Vector3]) -> void:
	if points.size() < 2:
		push_error("Patroller needs at least 2 points")
		return

	patrol_points = points
	destination = patrol_points[current_point]
