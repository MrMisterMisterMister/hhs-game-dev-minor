class_name CameraShake
extends Camera2D

@export var shake_intensity_limit: float = 30.0 ## The maximum (+ & -) shake effect. The higher this value, the more intense a shake will be.
@export var shake_fade_speed: float = 5.0 ## The speed with which the shaking will fade after starting.

var rng = RandomNumberGenerator.new() ## Create a random number generator
var shake_intensity: float = 0.0 ## The current intensity of the shake


## Set the shake intensity to the intensity limit at the start of the screen shake
func apply_shake(trauma: float) -> void:
	shake_intensity = min(trauma, shake_intensity_limit)


func _process(delta: float) -> void:
	rotate(deg_to_rad(90) * delta )
	## If shake intensity is more than 0, we are shaking the screen
	if shake_intensity > 0:
		## Decrease the shake intensity by lerping between the current intensity and 0.0
		shake_intensity = lerp(shake_intensity, 0.0, shake_fade_speed * delta)
		## The offset gets applied to the camera
		offset = _get_random_offset()

## This calculates a random offset between -current_shake_intensity and +current_shake_intensity
## on both the x and y axis
## Use rng to make the offset more 'random'
func _get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_intensity, shake_intensity),
		rng.randf_range(-shake_intensity, shake_intensity)
	)
