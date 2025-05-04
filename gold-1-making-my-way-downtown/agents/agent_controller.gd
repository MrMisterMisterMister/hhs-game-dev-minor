class_name AgentController
extends Node3D

@export var agent_types: Dictionary = {
	Agent.Type.NORMAL: null,
	Agent.Type.PATROLLER: null,
}

var agent_to_spawn: Agent.Type
var selected_agent: Agent = null
var patroller_temp_points: Dictionary[Vector3, Label3D] = {}

@onready var normal_agents: Node3D = $NormalAgents
@onready var patroller_agents: Node3D = $PatrollerAgents
@onready var temp_points: Node3D = $TempPoints


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos: Vector2 = event.position
		var camera: Camera3D = get_viewport().get_camera_3d()
		
		var from: Vector3 = camera.project_ray_origin(mouse_pos)
		var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * 1000
		
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
		var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var result: Dictionary = space_state.intersect_ray(query)
		
		if not result.is_empty():
			_handle_click_interaction(result)


func _handle_click_interaction(result: Dictionary) -> void:
	var collider = result.get("collider")
	var click_position: Vector3 = result.get("position")
	
	if collider is Agent:
		_handle_agent_click(collider)
	else:
		_handle_environment_click(click_position)


func _handle_agent_click(clicked_agent: Agent) -> void:
	if selected_agent == clicked_agent:
		# Deselect current agent
		selected_agent.selected = false
		selected_agent = null
		_clear_temp_points()
	else:
		# Select new agent
		if selected_agent: selected_agent.selected = false
		selected_agent = clicked_agent
		selected_agent.selected = true
		_clear_temp_points()


func _handle_environment_click(position: Vector3) -> void:
	if not selected_agent:
		# Spawn new agent if none selected
		if agent_types.get(agent_to_spawn):
			_spawn_agent(position)
	else:
		# Command selected agent
		match selected_agent.type:
			Agent.Type.NORMAL:
				selected_agent.destination = position
			Agent.Type.PATROLLER:
				_handle_patroller_points(position)


func _handle_patroller_points(position: Vector3) -> void:
	if patroller_temp_points.size() < 2:
		# Create visual marker
		var label: Label3D = Label3D.new()
		label.text = "POINT"
		label.font_size = 64
		label.outline_size = 24
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		temp_points.add_child(label)
		label.global_position = Vector3(position.x, position.y + 1.2, position.z)
		patroller_temp_points[position] = label

		if patroller_temp_points.size() == 2:
			# Set patrol route when we have 2 points
			var points := patroller_temp_points.keys()
			selected_agent.set_patrol_points(points)
			_clear_temp_points()


func _spawn_agent(position: Vector3) -> void:
	var agent: Agent = agent_types[agent_to_spawn].instantiate()
	
	match agent_to_spawn:
		Agent.Type.NORMAL:
			normal_agents.add_child(agent)
		Agent.Type.PATROLLER:
			patroller_agents.add_child(agent)
	
	agent.global_position = position
	selected_agent = agent
	selected_agent.selected = true
	print("Spawned and selected: ", agent_to_spawn)


func _clear_temp_points() -> void:
	patroller_temp_points.clear()
	for child in temp_points.get_children():
		temp_points.remove_child(child)
		child.queue_free()


func _set_agent_to_spawn(type: Agent.Type) -> void:
	agent_to_spawn = type
	print("Current agent spawn type: ", Agent.type_to_string(type))
