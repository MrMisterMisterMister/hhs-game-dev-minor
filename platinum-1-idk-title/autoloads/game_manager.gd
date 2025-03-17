extends Node

enum Menus {NONE, MAIN, PAUSE, GAME_OVER, SETTINGS}

var hud: Control
var main_menu: Control
var pause_menu: Control
var game_over_menu: Control
var settings_menu: Control
var previous_menu: Menus = Menus.MAIN
var current_menu: Menus = Menus.MAIN


var paused: bool:
	set(value):
		paused = value
		get_tree().paused = value


func _ready() -> void:
	_initialize()
	_connect_signals()


func _initialize() -> void:
	hud = load("uid://di8uvwjy31iqg").instantiate()
	main_menu = load("uid://b2vrewtctsacx").instantiate()
	pause_menu = load("uid://btdakvc1nwm4c").instantiate()
	game_over_menu = load("uid://udlpp7j45uci").instantiate()
	settings_menu = load("uid://gmmxbdt8ng3d").instantiate()
	
	main_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	game_over_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	settings_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	add_child(hud)
	add_child(main_menu)
	add_child(pause_menu)
	add_child(game_over_menu)
	add_child(settings_menu)
	
	_set_menu_visibility(Menus.MAIN, current_menu, false)
	
	LevelManager.parent = self
	SignalManager.settings_loaded.emit()


func _connect_signals() -> void:
	SignalManager.game_started.connect(_start_game)
	SignalManager.game_paused.connect(_pause_game)
	SignalManager.game_resumed.connect(_resume_game)
	SignalManager.game_ended.connect(_end_game)
	SignalManager.game_over.connect(_game_over)
	SignalManager.game_restarted.connect(_restart_game)
	SignalManager.game_exited.connect(_exit_game)
	SignalManager.game_settings.connect(_game_settings)


func _start_game():
	_set_menu_visibility(Menus.NONE, current_menu, false)
	LevelManager.change_level(1)


func _pause_game() -> void:
	if current_menu == Menus.MAIN:
		return
	_set_menu_visibility(Menus.PAUSE, current_menu, true)


func _resume_game() -> void:
	_set_menu_visibility(Menus.NONE, current_menu, false)


func _end_game() -> void:
	_set_menu_visibility(Menus.MAIN, current_menu, false)
	LevelManager.change_level(0)


func _game_over() -> void:
	_set_menu_visibility(Menus.GAME_OVER, current_menu, true)


func _restart_game() -> void:
	_set_menu_visibility(Menus.NONE, current_menu, false)
	LevelManager.change_level(1)


func _exit_game() -> void:
	get_tree().quit()


func _game_settings() -> void:
	SignalManager.settings_loaded.emit()
	
	if current_menu == Menus.SETTINGS:
		return_to_previous_menu()
		return
	
	_set_menu_visibility(Menus.SETTINGS, current_menu, true)


func return_to_previous_menu() -> void:
	var should_pause = previous_menu in [Menus.PAUSE, Menus.GAME_OVER]
	_set_menu_visibility(previous_menu, current_menu, should_pause)


func _set_menu_visibility(menu: Menus, prev_menu: Menus, set_pause: bool) -> void:
	paused = set_pause
	current_menu = menu
	previous_menu = prev_menu
	
	print("Current Menu", current_menu)
	print("Previous Menu", previous_menu)
	
	hud.visible = menu not in [Menus.MAIN, Menus.SETTINGS]
	main_menu.visible = menu == Menus.MAIN
	pause_menu.visible = menu == Menus.PAUSE
	game_over_menu.visible = menu == Menus.GAME_OVER
	settings_menu.visible = menu == Menus.SETTINGS
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if menu != Menus.NONE else Input.MOUSE_MODE_CAPTURED
