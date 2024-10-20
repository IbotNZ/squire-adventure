extends Control

@onready var visual_editor := $VisualEditor
@onready var right_click_menu := $MapSceneNodeList
var right_click_menu_location: Vector2

var paragraph_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/paragraph_node.tscn")
var exposition_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/exposition_node.tscn")
var hub_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/hub_node.tscn")
var start_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/start_node.tscn")
var end_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/end_node.tscn")
var bool_var_setter_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/bool_variable_setter.tscn")
var bool_logic_node := preload("res://dialogue_editor/editor_nodes/map_scene_nodes/bool_logic.tscn")

var connection_list: Array[NodeConnection]

var double_click_rect: Rect2

class NodeConnection:
	var from_node: StringName
	var from_port: int
	var to_node: StringName
	var to_port: int
	
	func _init(origin_node: StringName, origin_port: int, target_node: StringName, target_port: int) -> void:
		from_node = origin_node
		from_port = origin_port
		to_node = target_node
		to_port = target_port
	
	# Function for connections shifting when hub choices change


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		show_right_click_menu(get_local_mouse_position())
	elif event is InputEventMouseButton and event.is_double_click() and event.button_index == MOUSE_BUTTON_LEFT:
		var connection: Dictionary = visual_editor.get_closest_connection_at_point(get_local_mouse_position())
		if connection.size() > 0:
			disconnect_editor_node(connection.get("from_node"), connection.get("from_port"), connection.get("to_node"), connection.get("to_port"))


func show_right_click_menu(location: Vector2):
	right_click_menu_location = location
	right_click_menu.position = location
	right_click_menu.deselect_all()
	right_click_menu.show()


func delete_selected_nodes(nodes: Array[StringName]):
	for i in visual_editor.get_children():
		if nodes.has(i.name):
			for connection in connection_list:
				if connection.from_node == i.name or connection.to_node == i.name:
					connection_list.erase(connection)
			i.queue_free()


func is_there_connection_conflict(a: NodeConnection):
	var is_there_conflict := false
	for i in connection_list:
		if a.from_node == i.from_node and a.from_port == i.from_port and a.to_node == i.to_node and a.to_port == i.to_port:
			is_there_conflict = true
	return is_there_conflict


func get_connection(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var target_connection: NodeConnection
	for i in connection_list:
		if i.from_node == from_node and i.from_port == from_port and i.to_node == to_node and i.to_port == to_port:
			target_connection = i
	return target_connection


func connect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var new_connection := NodeConnection.new(from_node, from_port, to_node, to_port)
	if not is_there_connection_conflict(new_connection):
		connection_list.append(new_connection)
		visual_editor.connect_node(from_node, from_port, to_node, to_port)
	print(connection_list)


func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var connection_reference: NodeConnection = get_connection(from_node, from_port, to_node, to_port)
	connection_list.erase(connection_reference)
	visual_editor.disconnect_node(from_node, from_port, to_node, to_port)


func _on_map_scene_node_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var new_editor_node: GraphNode
	match index:
		0: # Paragraph
			new_editor_node = paragraph_node.instantiate()
		1: # Exposition
			new_editor_node = exposition_node.instantiate()
		2: # Hub
			new_editor_node = hub_node.instantiate()
		3: # Start
			new_editor_node = start_node.instantiate()
		4: # End
			new_editor_node = end_node.instantiate()
		5: # Bool Var Setter
			new_editor_node = bool_var_setter_node.instantiate()
		6: # Bool Logic
			new_editor_node = bool_logic_node.instantiate()
	visual_editor.add_child(new_editor_node)
	new_editor_node.position_offset = right_click_menu_location
	right_click_menu.hide()


func _on_visual_editor_delete_nodes_request(nodes: Array[StringName]) -> void:
	delete_selected_nodes(nodes)


func _on_visual_editor_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_editor_node(from_node, from_port, to_node, to_port)
