extends Control

@onready var player_health_bar: ProgressBar = %PlayerHealthBar
@onready var player_stamina_bar: ProgressBar = %PlayerStaminaBar
@onready var boss_health_bar: ProgressBar = %BossHealthBar
@onready var player_state_label: Label = $%PlayerStateLabel


func _ready() -> void:
	SignalManager.player_health_changed.connect(_update_player_health_bar)
	SignalManager.player_stamina_changed.connect(_update_player_stamina_bar)
	SignalManager.boss_health_changed.connect(_update_boss_health_bar)
	
	SignalManager.player_move_state_changed.connect(_update_player_state_label)


func _update_player_health_bar(amount: float) -> void:
	player_health_bar.value = amount


func _update_player_stamina_bar(amount: float) -> void:
	player_stamina_bar.value = amount


func _update_boss_health_bar(amount: float) -> void:
	boss_health_bar.value = amount


func _update_player_state_label(state: MoveState, info: Dictionary = {}) -> void:
	player_state_label.text = "current state: " + state.name
