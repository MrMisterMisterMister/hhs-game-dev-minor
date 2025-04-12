extends MoveState

@export_category("Transition States")
@export var idle_state: MoveState
@export var walk_state: MoveState
@export var run_state: MoveState
@export var jump_state: MoveState

@export_category("Movement")
@export var dash_speed: float = 50

var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector3 = Vector3.ZERO  # Store dash direction
var stamina_drain: float = 30.0

@onready var dash_duration: Timer = $DashDuration
@onready var dash_cooldown: Timer = $DashCooldown


func enter(prev_state: MoveState, _info: Dictionary = {}) -> void:
	super(prev_state, _info)
	
	if not can_dash or parent.stats.current_stamina < stamina_drain:
		SignalManager.player_move_state_changed.emit(previous_state)
		return
	
	parent.stats.drain_stamina(stamina_drain)
	
	is_dashing = true
	can_dash = false
	
	# Store the direction at the moment of dashing
	dash_direction = move_component.get_direction()
	if dash_direction == Vector3.ZERO:
		dash_direction = -parent.global_basis.z  # Default to forward direction
	
	move_component.move_speed = dash_speed
	
	dash_duration.start()
	dash_cooldown.start()
	
	animation_tree.set("parameters/DashOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func physics_process(delta: float) -> void:
	parent.velocity.y += move_component.get_gravity(parent.velocity) * delta
	
	if is_dashing:
		move_component.rotate_visual(delta)  # Re-enable rotation after dashing
		# Always use the stored direction instead of recalculating
		parent.velocity = dash_direction * dash_speed
	else:
		if parent.is_on_floor():
			var movement = move_component.get_direction()
			if movement == Vector3.ZERO:
				SignalManager.player_move_state_changed.emit(idle_state)
				return
			if Input.is_action_pressed("run"):
				SignalManager.player_move_state_changed.emit(run_state)
				return
			SignalManager.player_move_state_changed.emit(walk_state)
			return
		else:
			SignalManager.player_move_state_changed.emit(jump_state)
			return
	
	parent.move_and_slide()


func _on_dash_duration_timeout() -> void:
	is_dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
