extends Control

@onready var current_state_label: Label = $VBoxContainer/CurrentState


func _ready() -> void:
	SignalManager.state_changed.connect(_update_state)


func _update_state(current_state: State, previous_state: State) -> void:
	if previous_state and current_state:
		current_state_label.text = "Current State: " + current_state.name
