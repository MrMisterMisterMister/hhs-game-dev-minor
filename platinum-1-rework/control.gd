extends Control

@onready var current_state_label: Label = $VBoxContainer/CurrentState
@onready var current_state_2_label: Label = $VBoxContainer/CurrentState2
@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	SignalManager.move_state_changed.connect(_update_move_state)
	SignalManager.attack_state_changed.connect(_update_attack_state)
	SignalManager.stamina_changed.connect(_update_stamina_bar)


func _update_move_state(current_state: MoveState, previous_state: MoveState) -> void:
	if previous_state and current_state:
		current_state_label.text = "Current Move State: " + current_state.name


func _update_attack_state(current_state: AttackState, previous_state: AttackState) -> void:
	if previous_state and current_state:
		current_state_2_label.text = "Current Attack State: " + current_state.name


func _update_stamina_bar(value: float) -> void:
	progress_bar.value = value
