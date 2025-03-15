extends Node

var hud: Control
var main_menu: Control
var pause_menu: Control


@onready var is_paused: bool = get_tree().is_paused()


func _ready() -> void:
	_initialize()
	
	SignalManager.game_started.connect(_start_game)
	SignalManager.game_paused.connect(_pause_game)
	SignalManager.game_resumed.connect(_resume_game)
	SignalManager.game_ended.connect(_end_game)
	SignalManager.game_restarted.connect(_restart_game)
	SignalManager.game_exited.connect(_exit_game)
	
	LevelManager.parent = self
	
	print(is_paused)


func _initialize() -> void:
	hud = load("uid://di8uvwjy31iqg").instantiate()
	main_menu = load("uid://b2vrewtctsacx").instantiate()
	pause_menu = load("uid://btdakvc1nwm4c").instantiate()
	
	hud.visible = !hud.visible
	
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_menu.visible = !pause_menu.visible
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	add_child(hud)
	add_child(main_menu)
	add_child(pause_menu)


func _start_game():
	main_menu.visible = !main_menu.visible
	hud.visible = !hud.visible
	
	LevelManager.change_level(0)


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
