class_name AgentSelectorButton
extends Button

var active: bool = false:
	set(value):
		active = value
		if value:
			add_theme_stylebox_override("disabled", active_stylebox)
		else:
			add_theme_stylebox_override("disabled", inactive_stylebox)

@onready var active_stylebox: StyleBoxFlat = preload("uid://8mctd2tbsmhf")
@onready var inactive_stylebox: StyleBoxFlat = preload("uid://ic1mc7xpofcn")
