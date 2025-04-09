extends Node3D


func enemy_damagable(value: bool) -> void:
	SignalManager.enemy_damagable.emit(value)


func _on_shortsword_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_shortsword_2_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
