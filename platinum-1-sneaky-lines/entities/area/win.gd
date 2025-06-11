extends Area3D

var hud: Hud


func _ready() -> void:
	hud = get_tree().get_first_node_in_group("hud")


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		hud.game_won.emit(hud.GameType.WON)
