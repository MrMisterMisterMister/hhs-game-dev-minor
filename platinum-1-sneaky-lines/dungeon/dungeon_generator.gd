@tool
class_name DungeonGenerator
extends Node3D

################################################################################
## A procedural dungeon generator that creates rooms and connects them with 
## hallways. It uses a minimum spanning tree algorithm with Delaunay 
## triangulation to ensure all rooms are connected, with options to add extra 
## connections for more complex layouts.
################################################################################

signal generation_started
signal generation_finished

enum TileType {
	ROOM = 0,
	HALLWAY = 1,
	DOOR = 2,
	BORDER = 3
}

@export_category("Generation Settings")
## Trigger generation in the editor when set to true
@export var generate_dungeon: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			generate()
## Size of the dungeon area (square)
@export var dungeon_size: int = 20:
	set(value):
		dungeon_size = value
		if Engine.is_editor_hint():
			visualize_border()

## Chance (0-1) of additional hallways being added beyond the minimum required
@export_range(0.0, 1.0) var extra_connection_chance: float = 0.25
## Number of rooms to attempt to place
@export var room_count: int = 4
## Margin between rooms (in grid cells)
@export var room_margin: int = 1
## Number of retry attempts when placing rooms
@export var placement_attempts: int = 15
## Minimum room dimension (width/height)
@export var min_room_size: int = 2
## Maximum room dimension (width/height)
@export var max_room_size: int = 4
## Custom seed for reproducible generation
@export_multiline var generation_seed: String = "":
	set(value):
		generation_seed = value
		if value != "":
			seed(value.hash())

var room_tiles: Array[PackedVector3Array] = []
var room_centers: PackedVector3Array = []

@onready var grid_map: GridMap = $GridMap


## Initializes the dungeon border visualization
func _ready() -> void:
	if Engine.is_editor_hint():
		visualize_border()


## Draws the border of the dungeon area using BORDER tiles
func visualize_border() -> void:
	if not grid_map: 
		return

	grid_map.visible = true
	grid_map.clear()

	for i in range(-1, dungeon_size + 1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), TileType.BORDER)
		grid_map.set_cell_item(Vector3i(i, 0, dungeon_size), TileType.BORDER)
		grid_map.set_cell_item(Vector3i(dungeon_size, 0, i), TileType.BORDER)
		grid_map.set_cell_item(Vector3i(-1, 0, i), TileType.BORDER)


## Main generation function that creates the complete dungeon
func generate() -> void:
	generation_started.emit()

	# Reset rooms
	room_tiles.clear()
	room_centers.clear()

	# Apply custom seed if set
	if generation_seed:
		seed(generation_seed.hash())

	# Setup the dungeon border
	visualize_border()

	# Place rooms
	var successful_rooms: int = 0
	for i in room_count:
		successful_rooms += 1 if place_room(placement_attempts) else 0
		# Yield to avoid freezing the editor during generation
		if successful_rooms % 17 == 16:
			await get_tree().create_timer(0).timeout

	# Connect rooms with hallways if we have at least 2 rooms
	if room_centers.size() >= 2:
		generate_hallway_network()

	await get_tree().create_timer(2.0).timeout

	generation_finished.emit()


## Attempts to place a room at a random position
## Returns true if room was successfully placed
func place_room(attempts_left: int) -> bool:
	# Stop recursion if we've run out of attempts
	if attempts_left <= 0:
		return false

	# Generate random room dimensions
	var width: int = (randi() % (max_room_size - min_room_size + 1)) + min_room_size
	var height: int = (randi() % (max_room_size - min_room_size + 1)) + min_room_size

	# Choose a random position
	var start_position: Vector3i = Vector3i()
	start_position.x = randi() % (dungeon_size - width + 1)
	start_position.z = randi() % (dungeon_size - height + 1)

	# Check if the room (plus margin) overlaps with existing rooms
	for r in range(-room_margin, height + room_margin):
		for c in range(-room_margin, width + room_margin):
			var check_position: Vector3i = start_position + Vector3i(c, 0, r)
			if grid_map.get_cell_item(check_position) == TileType.ROOM:
				# Overlap detected, try again with one fewer attempt
				return place_room(attempts_left - 1)

	# No overlap found, place the room
	var room_tile_positions: PackedVector3Array = []
	for r in height:
		for c in width:
			var room_position: Vector3i = start_position + Vector3i(c, 0, r)
			grid_map.set_cell_item(room_position, TileType.ROOM)
			room_tile_positions.append(room_position)

	# Store room data
	room_tiles.append(room_tile_positions)

	# Calculate room center
	var center_x: float = start_position.x + (float(width) / 2.0)
	var center_z: float = start_position.z + (float(height) / 2.0)
	var room_center: Vector3 = Vector3(center_x, 0, center_z)
	room_centers.append(room_center)

	return true


## Creates a network of hallways connecting all rooms
func generate_hallway_network() -> void:
	# Convert room centers to 2D positions for pathfinding
	var room_positions_2d: PackedVector2Array = []

	# Setup graphs for Delaunay triangulation and MST
	var delaunay_graph: AStar2D = AStar2D.new()
	var mst_graph: AStar2D = AStar2D.new()

	# Add points to both graphs
	for pos in room_centers:
		var pos_2d: Vector2 = Vector2(pos.x, pos.z)
		room_positions_2d.append(pos_2d)

		var point_id: int = delaunay_graph.get_available_point_id()
		delaunay_graph.add_point(point_id, pos_2d)
		mst_graph.add_point(point_id, pos_2d)

	# Create Delaunay triangulation
	var triangulation: Array = Array(Geometry2D.triangulate_delaunay(room_positions_2d))

	# Add edges from triangulation to Delaunay graph
	for i in triangulation.size() / 3.0:
		var p1: int = triangulation.pop_front()
		var p2: int = triangulation.pop_front()
		var p3: int = triangulation.pop_front()

		delaunay_graph.connect_points(p1, p2)
		delaunay_graph.connect_points(p2, p3)
		delaunay_graph.connect_points(p1, p3)

	# Create minimum spanning tree
	var connected_points: PackedInt32Array = []
	connected_points.append(randi() % room_centers.size())

	while connected_points.size() < mst_graph.get_point_count():
		var possible_connections: Array[PackedInt32Array] = []

		# Find all possible new connections
		for point in connected_points:
			for connection in delaunay_graph.get_point_connections(point):
				if not connected_points.has(connection):
					possible_connections.append(PackedInt32Array([point, connection]))

		# Find the shortest connection
		var best_connection: PackedInt32Array = possible_connections[0]
		var best_distance: float = INF

		for connection in possible_connections:
			var p1_pos: Vector2 = room_positions_2d[connection[0]]
			var p2_pos: Vector2 = room_positions_2d[connection[1]]
			var distance: float = p1_pos.distance_squared_to(p2_pos)

			if distance < best_distance:
				best_connection = connection
				best_distance = distance

		# Add the connection to MST and remove from Delaunay
		connected_points.append(best_connection[1])
		mst_graph.connect_points(best_connection[0], best_connection[1])
		delaunay_graph.disconnect_points(best_connection[0], best_connection[1])

	# Create final hallway graph (MST with some random connections added back)
	var hallway_graph: AStar2D = mst_graph

	# Potentially add some edges back for more interesting layouts
	for point in delaunay_graph.get_point_ids():
		for connection in delaunay_graph.get_point_connections(point):
			if connection > point and randf() < extra_connection_chance:
				hallway_graph.connect_points(point, connection)

	# Create the actual hallways
	create_hallways(hallway_graph)


## Create hallways between connected rooms using A* pathfinding
func create_hallways(hallway_graph: AStar2D) -> void:
	var hallway_endpoints: Array[PackedVector3Array] = []

	# Find the best door positions for each hallway
	for point in hallway_graph.get_point_ids():
		for connection in hallway_graph.get_point_connections(point):
			if connection > point:  # Process each connection only once
				var from_room: PackedVector3Array = room_tiles[point]
				var to_room: PackedVector3Array = room_tiles[connection]

				# Find the best door positions (closest tiles between rooms)
				var from_door: Vector3 = _find_closest_tile(from_room, room_centers[connection])
				var to_door: Vector3 = _find_closest_tile(to_room, room_centers[point])

				# Mark door positions
				grid_map.set_cell_item(Vector3i(from_door), TileType.DOOR)
				grid_map.set_cell_item(Vector3i(to_door), TileType.DOOR)

				# Save hallway endpoints for pathfinding
				hallway_endpoints.append(PackedVector3Array([from_door, to_door]))
	
	# Setup A* grid for pathfinding
	var pathfinder: AStarGrid2D = AStarGrid2D.new()
	pathfinder.size = Vector2i.ONE * dungeon_size
	pathfinder.update()
	pathfinder.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinder.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN

	# Mark room tiles as solid (for pathfinding around them)
	for tile in grid_map.get_used_cells_by_item(TileType.ROOM):
		pathfinder.set_point_solid(Vector2i(tile.x, tile.z))

	# Create hallways between door points
	var hallway_count: int = 0
	for endpoints in hallway_endpoints:
		hallway_count += 1

		var from_pos: Vector2i = Vector2i(int(endpoints[0].x), int(endpoints[0].z))
		var to_pos: Vector2i = Vector2i(int(endpoints[1].x), int(endpoints[1].z))

		# Find path between doors
		var path: PackedVector2Array = pathfinder.get_point_path(from_pos, to_pos)

		# Place hallway tiles
		for point in path:
			var tile_pos: Vector3i = Vector3i(int(point.x), 0, int(point.y))
			if grid_map.get_cell_item(tile_pos) < 0:  # If cell is empty
				grid_map.set_cell_item(tile_pos, TileType.HALLWAY)

		# Yield occasionally to prevent editor freezing
		if hallway_count % 16 == 15:
			await get_tree().create_timer(0).timeout


## Finds the tile in a room closest to a target position
func _find_closest_tile(tiles: PackedVector3Array, target: Vector3) -> Vector3:
	var closest_tile: Vector3 = tiles[0]
	var closest_distance: float = closest_tile.distance_squared_to(target)

	for tile in tiles:
		var distance: float = tile.distance_squared_to(target)
		if distance < closest_distance:
			closest_tile = tile
			closest_distance = distance

	return closest_tile


func _toggle_visibility() -> void:
	visible = not visible
