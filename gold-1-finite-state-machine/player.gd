class_name Player
extends CharacterBody3D

@onready var move_state_machine: StateMachine = $MoveStateMachine
@onready var animation_player: AnimationPlayer = %Knight/AnimationPlayer
@onready var move_component: Node = $MoveComponent


func _ready() -> void:
	move_state_machine.init(self, animation_player, move_component)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	move_state_machine.input(event)


func _process(delta: float) -> void:
	move_state_machine.process(delta)


func _physics_process(delta: float) -> void:
	move_state_machine.physics_process(delta)
