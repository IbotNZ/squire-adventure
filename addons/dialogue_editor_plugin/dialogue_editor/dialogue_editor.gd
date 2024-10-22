@tool
extends Control

var editor_plugin: EditorPlugin

var global_variables: GlobalVariable = preload("res://addons/dialogue_editor_plugin/dialogue_objects/variable_nodes/global_variable.tres")

@onready var visual_editor := $VisualEditor
@onready var variable_editor := $VariableEditor
@onready var right_click_menu := $MapSceneNodeList
@onready var variable_right_click_menu := $VariableNodeList
var right_click_menu_location: Vector2
var right_click_variable_menu_location: Vector2

var paragraph_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/paragraph_node.tscn")
var exposition_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/exposition_node.tscn")
var hub_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/hub_node.tscn")
var start_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/start_node.tscn")
var end_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/end_node.tscn")
var bool_var_setter_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/bool_variable_setter.tscn")
var bool_logic_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/bool_logic.tscn")
var bool_variable_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/bool_variable.tscn")

var connection_list: Array[NodeConnection]

var double_click_rect: Rect2

enum mode {scene_editor, variable_editor}
var editor_mode: int = mode.scene_editor
@onready var editor_switcher := $EditorSwitcher

var is_mouse_on_map_scene_menu: bool

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


func _ready() -> void:
	sync_variable_editor()


func _input(event: InputEvent) -> void:
	#if editor_plugin.get_editor_interface().get_editor_main_screen().name == "Dialogue Editor":
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		show_right_click_menu(get_local_mouse_position())
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and is_mouse_on_map_scene_menu == false:
		right_click_menu.hide()
		variable_right_click_menu.hide()
	elif event is InputEventMouseButton and event.is_double_click() and event.button_index == MOUSE_BUTTON_LEFT:
		var connection: Dictionary = visual_editor.get_closest_connection_at_point(get_local_mouse_position())
		if connection.size() > 0:
			disconnect_editor_node(connection.get("from_node"), connection.get("from_port"), connection.get("to_node"), connection.get("to_port"))


func sync_variable_editor():
	var new_node: GraphNode
	for i in global_variables.stored_variables:
		if i is DialogueBoolVariable:
			new_node = bool_variable_node.instantiate()
			variable_editor.add_child(new_node)


func change_editor_mode(selected_mode: mode):
	editor_mode = selected_mode
	if selected_mode == mode.scene_editor:
		editor_switcher.text = "Edit Variables"
		variable_editor.hide()
		visual_editor.show()
	elif selected_mode == mode.variable_editor:
		editor_switcher.text = "Edit Game Scene"
		variable_editor.show()
		visual_editor.hide()


func show_right_click_menu(location: Vector2):
	right_click_menu_location = (location + visual_editor.scroll_offset) / visual_editor.zoom
	right_click_variable_menu_location = (location + variable_editor.scroll_offset) / variable_editor.zoom
	if editor_mode == mode.scene_editor:
		right_click_menu.position = location
		right_click_menu.deselect_all()
		right_click_menu.show()
	elif editor_mode == mode.variable_editor:
		variable_right_click_menu.position = location
		variable_right_click_menu.deselect_all()
		variable_right_click_menu.show()


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
		for i in connection_list:
			if i.from_node == new_connection.from_node:
				disconnect_editor_node(i.from_node, i.from_port, i.to_node, i.to_port)
		connection_list.append(new_connection)
		visual_editor.connect_node(from_node, from_port, to_node, to_port)
	
	#print(connection_list)


func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var connection_reference: NodeConnection = get_connection(from_node, from_port, to_node, to_port)
	connection_list.erase(connection_reference)
	visual_editor.disconnect_node(from_node, from_port, to_node, to_port)


func node_list_menu_clicked(index: int, mouse_button_index: int):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		var new_editor_node: GraphNode
		if editor_mode == mode.scene_editor:
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
		elif editor_mode == mode.variable_editor:
			match index:
				0: # Bool Variable
					create_dialogue_node("bool_variable_node", variable_editor)
			variable_right_click_menu.hide()


func create_dialogue_node(node_type: StringName, graph_edit: GraphEdit):
	var new_editor_node: GraphNode
	var new_dialogue_resource: DialogueType
	match node_type:
		"bool_variable_node":
			new_editor_node = bool_variable_node.instantiate()
			new_dialogue_resource = DialogueBoolVariable.new()
	graph_edit.add_child(new_editor_node)
	if editor_mode == mode.scene_editor:
		new_editor_node.position_offset = right_click_menu_location
	elif editor_mode == mode.variable_editor:
		new_editor_node.position_offset = right_click_variable_menu_location
	global_variables.stored_variables.append(new_dialogue_resource)
	ResourceSaver.save(global_variables, "res://addons/dialogue_editor_plugin/dialogue_objects/variable_nodes/global_variable.tres")


func _on_map_scene_node_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	node_list_menu_clicked(index, mouse_button_index)


func _on_visual_editor_delete_nodes_request(nodes: Array[StringName]) -> void:
	delete_selected_nodes(nodes)


func _on_visual_editor_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_editor_node(from_node, from_port, to_node, to_port)


func _on_editor_switcher_pressed() -> void:
	if editor_mode == mode.scene_editor:
		change_editor_mode(mode.variable_editor)
	elif  editor_mode == mode.variable_editor:
		change_editor_mode(mode.scene_editor)
	#editor_switcher.


func _on_map_scene_node_list_mouse_entered() -> void:
	is_mouse_on_map_scene_menu = true


func _on_map_scene_node_list_mouse_exited() -> void:
	is_mouse_on_map_scene_menu = false


func _on_variable_node_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print("Test")
	node_list_menu_clicked(index, mouse_button_index)


func _on_variable_node_list_mouse_entered() -> void:
	is_mouse_on_map_scene_menu = true


func _on_variable_node_list_mouse_exited() -> void:
	is_mouse_on_map_scene_menu = false
