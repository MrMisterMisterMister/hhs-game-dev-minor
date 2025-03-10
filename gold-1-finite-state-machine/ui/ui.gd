extends Control

@onready var label: Label = $Label


func _on_state_machine_state_changed(current_state: State) -> void:
	if label != null:
		label.text = "Current State: " + current_state.name
