class_name BaseEnemy
extends CharacterBody3D

@export var target: Node3D


func _ready() -> void:
	print(target)
