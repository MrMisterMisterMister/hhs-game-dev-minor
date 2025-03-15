extends Node

var level: Node3D
var hud: Control
var pause_menu: Control


@onready var is_paused: bool = get_tree().is_paused()


func _ready() -> void:
	_initialize()
	
	SignalManager.game_paused.connect(_pause_game)
	SignalManager.game_resumed.connect(_resume_game)
	SignalManager.game_ended.connect(_end_game)
	SignalManager.game_restarted.connect(_restart_game)
	SignalManager.game_exited.connect(_exit_game)
	
	print("Paused: ", is_paused)


func _initialize() -> void:
	hud = load("uid://di8uvwjy31iqg").instantiate()
	level = load("uid://dmvvwvp5bqimb").instantiate()
	pause_menu = load("uid://btdakvc1nwm4c").instantiate()
	
	level.process_mode = Node.PROCESS_MODE_PAUSABLE
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_menu.visible = !pause_menu.visible
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	add_child(hud)
	add_child(level)
	add_child(pause_menu)


func _pause_game() -> void:
	is_paused = !is_paused
	pause_menu.visible = !pause_menu.visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	print("Game Paused: ", is_paused)
	get_tree().paused = is_paused


func _resume_game() -> void:
	is_paused = !is_paused
	pause_menu.visible = !pause_menu.visible
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	print("Game Paused: ", is_paused)
	get_tree().paused = is_paused


func _end_game() -> void:
	pass


func _restart_game() -> void:
	pass


func _exit_game() -> void:
	pass
