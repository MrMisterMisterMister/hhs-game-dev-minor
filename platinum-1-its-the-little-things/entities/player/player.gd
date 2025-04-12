class_name Player
extends CharacterBody3D

@export var stats: Stats

@onready var move_state_machine: MoveStateMachine = $MoveStateMachine
@onready var attack_state_machine: AttackStateMachine = $AttackStateMachine
@onready var animation_tree: AnimationTree = %Knight/AnimationTree
@onready var move_component: Node = $MoveComponent
@onready var combat_component: Node = $CombatComponent


func _ready() -> void:
	move_state_machine.init(self, animation_tree, move_component, combat_component)
	attack_state_machine.init(self, animation_tree, move_component, combat_component)
	
	stats.init()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.player = self


func _input(event: InputEvent) -> void:
	move_state_machine.input(event)
	attack_state_machine.input(event)


func _process(delta: float) -> void:
	move_state_machine.process(delta)
	attack_state_machine.process(delta)
	
	SignalManager.player_health_changed.emit(stats.current_health)
	SignalManager.player_stamina_changed.emit(stats.current_stamina)


func _physics_process(delta: float) -> void:
	move_state_machine.physics_process(delta)
	attack_state_machine.physics_process(delta)
