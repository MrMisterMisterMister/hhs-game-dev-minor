extends Node3D

var ap: AnimationPlayer

@onready var knight: Node3D = $Knight


func _ready() -> void:
	ap = knight.get_node("AnimationPlayer")


func _process(delta: float) -> void:
	if not ap.is_playing():
		ap.play("Jump_Idle")
