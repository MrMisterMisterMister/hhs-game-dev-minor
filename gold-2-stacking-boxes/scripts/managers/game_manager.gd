extends Node3D

var hud: Control
var level: Node3D


func _ready() -> void:
	initialize()
	
	SignalManager.game_over.connect(game_over)
	SignalManager.game_restarted.connect(game_restarted)


func initialize() -> void:
	hud = load("uid://ch7xqfpk6eicp").instantiate()
	level = load("uid://d4ep0xpmdtmsn").instantiate()
	
	add_child(hud)
	add_child(level)


func game_over() -> void:
	hud.visible = true
	get_tree().paused = true


func game_restarted() -> void:
	var children = get_tree().current_scene.get_children()
	
	for child in children:
		child.queue_free()
		remove_child(child)
	
	initialize()
	
	get_tree().paused = false
