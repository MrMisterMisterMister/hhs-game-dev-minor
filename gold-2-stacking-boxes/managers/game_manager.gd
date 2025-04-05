extends Node

var level: Node3D


func _ready() -> void:
	initialize()
	
	SignalManager.game_ended.connect(_game_ended)
	SignalManager.game_restarted.connect(_game_restarted)


func initialize() -> void:
	level = load("uid://p7wxx6nd4og0").instantiate()
	
	add_child(level)


func _game_ended() -> void:
	var game_over_ui: Control = load("uid://btr16f3bx77dd").instantiate()
	
	add_child(game_over_ui)
	get_tree().paused = true


func _game_restarted() -> void:
	var children = get_tree().current_scene.get_children()
	
	for child in children:
		child.queue_free()
		remove_child(child)
	
	initialize()
	
	get_tree().paused = false
