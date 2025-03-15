extends Control

@onready var label: Label = $Label

func _ready() -> void:
	SignalManager.state_changed.connect(_on_state_changed)


func _on_state_changed(current_state: State) -> void:
	if label != null:
		label.text = "Current State: " + current_state.name
