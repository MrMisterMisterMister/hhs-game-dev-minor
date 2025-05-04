extends Agent

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	if not is_equal_approx(velocity.length(), 0):
		animation_player.play("roll")
	else:
		animation_player.stop()
	
	super(delta)
