@tool
class_name RoomGenerator
extends Node3D

################################################################################
# Generates rooms, hallways, and doors in a dungeon using a GridMap.
# It instantiates room scenes at each valid cell and removes walls or doors 
# between adjacent cells. based on their types (room, hallway, door, or none).
# The script is designed to be used as a tool in the Godot editor, allowing for
# dungeon generation instantaneously.
################################################################################

@export var grid_map: GridMap
@export var generate: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			create_dungeon()

var directions: Dictionary = {
	"front": Vector3i.FORWARD,
	"back": Vector3i.BACK,
	"left": Vector3i.LEFT,
	"right": Vector3i.RIGHT
}

var spawn_point_placed: bool = false


func handle_wall_removal(cell: Node3D, dir: String, cell_index: int, neighbor_index: int) -> void:
	# Remove wall if needed based on cell and neighbor types
	# Only keep walls for (0,1) and (1,0) pairs
	if (cell_index == 0 and neighbor_index == 1) or (cell_index == 1 and neighbor_index == 0):
		return
	cell.call("remove_wall_" + dir)


func create_dungeon() -> void:
	grid_map.visible = false
	visible = true

	# Remove existing children
	for c in get_children():
		remove_child(c)
		c.queue_free()

	# Reset spawn point flag
	spawn_point_placed = false

	var time: int = 0
	for cell in grid_map.get_used_cells():
		var cell_index: int = grid_map.get_cell_item(cell)
		if cell_index == -1 or cell_index == 3: # Border or empty cell
			continue

		var room_resource: PackedScene = preload("uid://70gt4lsc4fs")
		var room: Node3D = room_resource.instantiate()
		room.position = Vector3(cell) + Vector3(0.5, 0, 0.5)
		add_child(room)
		room.set_owner(owner)
		time += 1

		# Add spawn point to the first room we find
		if cell_index == 0 and not spawn_point_placed:
			add_spawn_point(room.position)
			spawn_point_placed = true

		for i in range(directions.size()):
			var dir_name: String = directions.keys()[i]
			var dir_vec: Vector3i = directions.values()[i]
			var cell_n: Vector3i = cell + dir_vec
			var cell_n_index: int = grid_map.get_cell_item(cell_n)
			if cell_n_index == -1 or cell_n_index == 3: # Border or empty cell
				continue

			handle_wall_removal(room, dir_name, cell_index, cell_n_index)

		# Yield to avoid freezing the editor for large dungeons
		if time % 10 == 9:
			await get_tree().create_timer(0).timeout


func add_spawn_point(spawn_position: Vector3) -> void:
	var spawn_marker: Marker3D = Marker3D.new()
	spawn_marker.name = "PlayerSpawn"
	spawn_marker.position = spawn_position
	add_child(spawn_marker)
	spawn_marker.set_owner(owner)
