extends Area3D


func _on_body_entered(body: Node3D) -> void:
	print("You Died...")
	SignalManager.game_over.emit()
