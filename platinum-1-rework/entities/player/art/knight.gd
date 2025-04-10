extends Node3D

# Weapon data: { RayCast3D: has_hit_enemy }
var weapons: Dictionary = {}
var enemy_damagable: bool = false

@onready var shortsword: RayCast3D = %Shortsword
@onready var shortsword_2: RayCast3D = %Shortsword2


func _ready():
	# Initialize weapons with their damage values and hit states
	weapons = {
		shortsword: {"damage": 5.5, "has_hit": false},
		shortsword_2: {"damage": 5.5, "has_hit": false}
	}


func set_enemy_damagable(value: bool) -> void:
	enemy_damagable = value
	# Reset hit states when attack starts/ends
	if !value:
		for weapon in weapons:
			weapons[weapon]["has_hit"] = false


func _physics_process(delta: float) -> void:
	if not enemy_damagable:
		return
	
	for weapon: RayCast3D in weapons:
		weapon.force_raycast_update()
		var collider = weapon.get_collider()
		
		# Check if weapon collided with an enemy and hasn't hit yet
		if (collider && 
			collider.collision_layer == 4 && 
			not weapons[weapon]["has_hit"]):
			
			damage_enemy(collider, weapons[weapon]["damage"])
			weapons[weapon]["has_hit"] = true  # Mark as hit


func damage_enemy(enemy: Node3D, damage: float) -> void:
	enemy.combat_component.get_hit({"damage": damage})
