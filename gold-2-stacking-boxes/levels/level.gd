extends Node3D

@export var spawner_offset: Vector3 = Vector3(0, 5.0, 0)

@onready var camera: Node3D = $CameraController
@onready var spawner: Spawner = $Spawner
@onready var hud: Control = $HUD


func _ready() -> void:
	camera.global_position.y = 3.0
	
	await get_tree().create_timer(5.0).timeout


func _process(_delta: float) -> void:
	spawner.global_position.y = camera.get_camera().global_position.y - spawner_offset.y
	spawner.set_spawn_position(get_spawn_position())
	
	var spawned_stackables: float = get_tree().get_first_node_in_group("stackables_counter").get_children().size()
	var height: float = camera.get_highest_height()
	
	hud.update_values(height, spawned_stackables)


func get_spawn_position():
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.get_camera().project_ray_origin(mouse_position)
	var to = camera.get_camera().project_ray_normal(mouse_position) - Vector3(0.0, 1.0, 0.0)
	
	return from + to


func _on_deadzone_body_entered(body: Node3D) -> void:
	if body.is_in_group("stackable"):
		SignalManager.game_ended.emit()
