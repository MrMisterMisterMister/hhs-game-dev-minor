class_name Player
extends CharacterBody3D

@export var mouse_sens_horizontal: float = 0.2
@export var mouse_sens_vertical: float = 0.1
@export var camera_smooth_speed: float = 10.0

@onready var movement_state_machine: StateMachine = $StateMachine
@onready var move_component: Node = $MoveComponent
@onready var animation_player: AnimationPlayer = $Visuals/Knight/AnimationPlayer


func _ready() -> void:
	movement_state_machine.init(self, animation_player, move_component)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	movement_state_machine.input(event)


func _process(delta: float) -> void:
	movement_state_machine.process(delta)


func _physics_process(delta: float) -> void:
	movement_state_machine.physics_process(delta)
