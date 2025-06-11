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


@export var generate: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			create_dungeon()
@export var clear_children: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			for child in get_children():
				remove_child(child)
				child.queue_free()
@export var spawn_dragon: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			_spawn_dragons()
@export var clear_dragons: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			_clear_dragons()
@export var grid_map: GridMap
@export var nav_region: NavigationRegion3D
@export var navigation: bool = false
@export var bake_nav_mesh: bool = false:
	set(value):
		if Engine.is_editor_hint() and value and navigation:
			_bake_region()
@export var clear_nav_mesh: bool = false:
	set(value):
		if Engine.is_editor_hint() and value and navigation:
			_clear_region()
@export var dragon_resources: Array[PackedScene]

var directions: Dictionary = {
	"front": Vector3i.FORWARD,
	"back": Vector3i.BACK,
	"left": Vector3i.LEFT,
	"right": Vector3i.RIGHT
}
var _room_cells: Array = []
var _spawned_dragons: Array[AspiringDragon] = []
var _spawn_point: Vector3

@onready var player_resource: PackedScene = preload("uid://c6b1cob16shyp")
@onready var win_resource: PackedScene = preload("uid://dfmor5d3mecc0")


func handle_wall_removal(cell: Node3D, dir: String, cell_index: int, neighbor_index: int) -> void:
	# Remove wall if needed based on cell and neighbor types
	# Only keep walls for (0,1) and (1,0) pairs
	if (cell_index == 0 and neighbor_index == 1) or (cell_index == 1 and neighbor_index == 0):
		return
	cell.call("remove_wall_" + dir)


func create_dungeon() -> void:
	grid_map.visible = false
	nav_region.visible = true

	# Remove existing children
	for c in get_children():
		remove_child(c)
		c.queue_free()

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

		var walls_removed: int = 0
		for i in range(directions.size()):
			var dir_name: String = directions.keys()[i]
			var dir_vec: Vector3i = directions.values()[i]
			var cell_n: Vector3i = cell + dir_vec
			var cell_n_index: int = grid_map.get_cell_item(cell_n)

			if cell_n_index == -1 or cell_n_index == 3: # Border or empty cell
				continue

			handle_wall_removal(room, dir_name, cell_index, cell_n_index)

			walls_removed += 1
			if walls_removed == 4:
				var room_position: Vector3 = grid_map.map_to_local(_spawn_point)
				_room_cells.append(cell)


		# Yield to avoid freezing the editor for large dungeons
		if time % 10 == 9:
			await get_tree().create_timer(0).timeout

	if navigation:
		_bake_region()
	else:
		_spawn_player()


# I'm so creative with names
func _spawn_win() -> void:
	var win: Area3D = win_resource.instantiate()
	add_child(win)

	win.global_position = _room_cells.pick_random()


func _spawn_player() -> void:
	await get_tree().create_timer(3.0)
	# Create player at spawn point
	var player: Player = player_resource.instantiate()
	add_child(player)
	player.set_owner(get_tree().edited_scene_root)  # Important for tool scripts

	player.global_position = _room_cells.pick_random() + Vector3i(0, 1, 0)

	print("Player spawned at: ", _spawn_point)


func _spawn_dragons() -> void:
	var spawn_positions: Array

	for dragon_resource in dragon_resources:
		await get_tree().create_timer(1.0).timeout

		var dragon: AspiringDragon = dragon_resource.instantiate()
		add_child(dragon)
		dragon.global_position = _room_cells.pick_random()

		while dragon.global_position in spawn_positions and dragon.global_position != _spawn_point:
			dragon.global_position = _room_cells.pick_random()

		_spawned_dragons.append(dragon) # Not used for now
		spawn_positions.append(dragon.global_position)

		dragon.start_moving()


func  _bake_region() -> void:
	if not nav_region:
		return
	if not nav_region.bake_finished.is_connected(_on_bake_finished):
		nav_region.bake_finished.connect(_on_bake_finished)

	NavigationServer3D.map_set_cell_size(
		get_world_3d().navigation_map,
		nav_region.navigation_mesh.cell_size
		)

	NavigationServer3D.map_set_cell_height(
	get_world_3d().navigation_map,
	nav_region.navigation_mesh.cell_height
	)

	nav_region.bake_navigation_mesh()


func _clear_region() -> void:
	if not nav_region:
		return

	nav_region.navigation_mesh.clear()


func _on_bake_finished() -> void:
	if Engine.is_editor_hint():
		return

	_spawn_dragons()
	_spawn_player()
	_spawn_win()


func _clear_dragons() -> void:
	for child in get_children():
		if child is AspiringDragon:
			remove_child(child)
			child.queue_free()


func _toggle_visibility() -> void:
	nav_region.visible = false

	for child in get_children():
		remove_child(child)
		child.queue_free()

	_clear_region()
