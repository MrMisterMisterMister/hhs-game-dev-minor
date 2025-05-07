class_name Tile
extends StaticBody2D

@export var ball: Ball

@onready var polygon_2d: Polygon2D = $Polygon2D


func _ready() -> void:
	set_color()


func toggle(collided_ball: Ball) -> void:
	ball = collided_ball

	# Set collision layer to layer that the collided ball is on.
	collision_layer = ball._get_collision_layer()

	set_color()


func set_color() -> void:
	# Set the colour to the opposite ball's colour
	var tween: Tween = polygon_2d.create_tween()
	tween.tween_property(polygon_2d, "color", Color(0, 0, 0), 0.1)

	if ball.is_ball_one:
		polygon_2d.color = ball.colour_ball_two
		tween.chain().tween_property(polygon_2d, "color", ball.colour_ball_two, 0.1)
	else:
		polygon_2d.color = ball.colour_ball_one
		tween.chain().tween_property(polygon_2d, "color", ball.colour_ball_one, 0.1)
