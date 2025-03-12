extends Node3D

var time_passed: float = 0.0
var sin_speed: float = 10
var cos_speed: float = 12
var sin_amplitude: float = 15.0
var cos_amplitude: float = 10.0
var move_direction: bool = true

func _process(delta: float) -> void:
	time_passed += delta
	rotation_degrees.x = sin(time_passed * sin_speed) * sin_amplitude
	rotation_degrees.z = cos(time_passed * cos_speed) * cos_amplitude
	
