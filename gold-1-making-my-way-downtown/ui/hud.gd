class_name Hud
extends Control

signal agent_selected(type: Agent.Type)

@onready var button_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var agent_selector_button: PackedScene = preload("uid://ea4a7j310irx")


func _ready() -> void:
	for type in Agent.Type:
		var button: AgentSelectorButton = agent_selector_button.instantiate()

		button.focus_entered.connect(_on_button_focused_entered.bind(button, type))
		button_container.add_child(button)
		button.text = type

	button_container.get_child(0).grab_focus()


func _on_button_focused_entered(button: AgentSelectorButton, type: String) -> void:
	for child: AgentSelectorButton in button_container.get_children():
		child.active = child == button

	agent_selected.emit(Agent.Type.get(type))
