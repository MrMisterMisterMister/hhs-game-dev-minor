class_name BaseEnemy
extends CharacterBody3D

@export var target: Node3D
@export var stats: Stats

func _ready() -> void:
	print(target)
