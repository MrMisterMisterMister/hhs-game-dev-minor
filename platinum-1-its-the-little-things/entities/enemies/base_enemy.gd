class_name BaseEnemy
extends CharacterBody3D

@export var target: Node3D
@export var stats: Stats

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var visual: Node3D = $Visual
