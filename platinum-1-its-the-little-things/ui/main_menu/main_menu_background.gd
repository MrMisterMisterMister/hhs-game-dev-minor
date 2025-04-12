extends Node3D

@onready var skeleton_mage: AnimationPlayer = $Skeleton_Mage/AnimationPlayer
@onready var skeleton_minion: AnimationPlayer = $Skeleton_Minion/AnimationPlayer


func _ready() -> void:
	skeleton_mage.play("Spawn_Ground_Skeletons")
	$Skeleton_Mage.visible = true
	
	await get_tree().create_timer(1).timeout
	
	skeleton_minion.play("Spawn_Ground_Skeletons")
	await get_tree().process_frame
	$Skeleton_Minion.visible = true
	
	await skeleton_mage.animation_finished
	
	skeleton_mage.play("Taunt_Longer")
	
	await skeleton_minion.animation_finished
	
	skeleton_minion.play("Taunt_Longer")
