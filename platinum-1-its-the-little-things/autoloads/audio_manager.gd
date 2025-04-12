## Autoload for playing SFX, credits to mrcdk from:
## https://forum.godotengine.org/t/best-proper-way-to-do-ui-sounds-hover-click/39081/2
extends Node

var playback: AudioStreamPlaybackPolyphonic


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _enter_tree() -> void:
	var player = AudioStreamPlayer.new()
	add_child(player)
	
	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.bus = "SFX"
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	
	get_tree().node_added.connect(on_node_added)


func on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and 
		# pressed signals and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_hover() -> void:
	playback.play_stream(preload("res://assets/audio/glitch_004.ogg"), 0, 0, randf_range(0.9, 1.1))


func _play_pressed() -> void:
	playback.play_stream(preload("res://assets/audio/select_006.ogg"), 0, 0, randf_range(0.9, 1.1))
