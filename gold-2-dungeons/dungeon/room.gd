@tool
class_name Room
extends Node3D

@onready var room_floor: MeshInstance3D = $Floor
@onready var room_ceiling: MeshInstance3D = $Ceiling
@onready var wall_right: MeshInstance3D = $WallRight
@onready var wall_left: MeshInstance3D = $WallLeft
@onready var wall_back: MeshInstance3D = $WallBack
@onready var wall_front: MeshInstance3D = $WallFront


func remove_wall_front():
	wall_front.free()
func remove_wall_back():
	wall_back.free()
func remove_wall_left():
	wall_left.free()
func remove_wall_right():
	wall_right.free()
