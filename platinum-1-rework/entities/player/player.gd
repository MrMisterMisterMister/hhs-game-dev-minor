class_name Player
extends CharacterBody3D

@export var stats: Stats

@onready var move_state_machine: MoveStateMachine = $MoveStateMachine
@onready var attack_state_machine: AttackStateMachine = $AttackStateMachine
@onready var animation_tree: AnimationTree = %Knight/AnimationTree
@onready var move_component: Node = $MoveComponent
@onready var combat_component: Node = $CombatComponent

var stamina: float = 100:
	set(value): 
		stamina = clamp(value, 0, 100)
		SignalManager.stamina_changed.emit(stamina/100 * 100)


func _ready() -> void:
	move_state_machine.init(self, animation_tree, move_component, combat_component)
	attack_state_machine.init(self, animation_tree, move_component, combat_component)
	
	stats.init()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	move_state_machine.input(event)
	attack_state_machine.input(event)


func _process(delta: float) -> void:
	move_state_machine.process(delta)
	attack_state_machine.process(delta)


func _physics_process(delta: float) -> void:
	move_state_machine.physics_process(delta)
	attack_state_machine.physics_process(delta)
