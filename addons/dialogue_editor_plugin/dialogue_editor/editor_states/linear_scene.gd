@tool
extends Node

@onready var root: DialogueEditor = $"../.."
@onready var visual_editor: GraphEdit = $"../../VisualEditor"
@onready var right_click_menu := $MapSceneNodeList
var right_click_menu_location: Vector2

var visual_editor_scene := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/editors/visual_editor.tscn")

var paragraph_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/paragraph_node.tscn")
var exposition_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/exposition_node.tscn")
var hub_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/hub_node.tscn")
var start_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/start_node.tscn")
var end_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/end_node.tscn")
var bool_var_setter_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/bool_variable_setter.tscn")
var bool_logic_node := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/bool_logic.tscn")

var connection_list: Array

func on_input(event: InputEvent):
	if root.is_mouse_on_editor:
		#if editor_plugin.get_editor_interface().get_editor_main_screen().name == "Dialogue Editor":
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			show_right_click_menu(root.get_local_mouse_position())
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and root.is_mouse_on_map_scene_menu == false:
			right_click_menu.hide()
		if event is InputEventMouseButton and event.is_double_click() and event.button_index == MOUSE_BUTTON_LEFT:
			var connection: Dictionary = root.visual_editor.get_closest_connection_at_point(root.get_local_mouse_position())
			if connection.size() > 0:
				disconnect_editor_node(connection.get("from_node"), connection.get("from_port"), connection.get("to_node"), connection.get("to_port"))


func show_right_click_menu(location: Vector2):
	right_click_menu_location = (location + root.visual_editor.scroll_offset) / root.visual_editor.zoom
	right_click_menu.position = location
	right_click_menu.deselect_all()
	right_click_menu.show()


func sync_visual_editor(dialogue_manager: DialogueManager):
	var current_dialogue_manager = dialogue_manager
	var new_editor_node: VisualEditorNode
	for i in dialogue_manager.dialogue_list:
		if i is DialogueStart:
			new_editor_node = start_node.instantiate()
		elif i is DialogueEnd:
			new_editor_node = end_node.instantiate()
		elif i is DialogueNode:
			new_editor_node = paragraph_node.instantiate()
		elif i is DialogueExposition:
			new_editor_node = exposition_node.instantiate()
		elif i is DialogueHub:
			new_editor_node = hub_node.instantiate()
		elif i is DialogueBoolLogic:
			new_editor_node = bool_logic_node.instantiate()
		elif i is DialogueBoolSetter:
			new_editor_node = bool_var_setter_node.instantiate()
		new_editor_node.node_resource = i
		new_editor_node.position_offset = i.graph_position
		root.visual_editor.add_child(new_editor_node)
	
	await Engine.get_main_loop().process_frame
	# Sync editor node connections
	for i in root.visual_editor.get_children():
		if i is VisualEditorNode:
			if i.node_resource.next_node != null:
				var target = get_visual_editor_resource_connection(i.node_resource.next_node)
				# Some nodes need custom logic
				if i is BoolLogicNode:
					pass
				elif i is HubNode:
					pass
				else:
					#connection_list.append(NodeConnection.new(i.name, 0, target.name, 0))
					#visual_editor.connect_node(i.name, 0, target.name, 0)
					connect_editor_node(i.name, 0, target.name, 0)


func get_visual_editor_resource_connection(searching_resource: DialogueType):
	var target
	for i in root.visual_editor.get_children():
		if i is VisualEditorNode:
			if i.node_resource == searching_resource:
				target = i
	return target


func is_there_connection_conflict(a: Array):
	var is_there_conflict := false
	for i in connection_list:
		if i[0] == a[0] and i[1] == a[1] and i[2] == a[2] and i[3] == a[3]:
			is_there_conflict = true
	return is_there_conflict


func connect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var new_connection := [from_node, from_port, to_node, to_port]
	if not is_there_connection_conflict(new_connection):
		for i in connection_list:
			if i[0] == new_connection[0] and i[1] == new_connection[1]:
				disconnect_editor_node(i.from_node, i.from_port, i.to_node, i.to_port)
				connection_list.erase(i)
		
		for i in root.visual_editor.get_children():
			if i.name == from_node:
				if i is BoolLogicNode:
					pass
				if i is BoolVarSetterNode:
					i.node_resource.next_node = root.get_visual_editor_node_resource(to_node)
				if i is ParagraphNode:
					i.node_resource.next_node = root.get_visual_editor_node_resource(to_node)
				if i is ExpositionNode:
					pass
				if i is StartNode:
					i.node_resource.next_node = root.get_visual_editor_node_resource(to_node)
				if i is EndNode:
					pass
				if i is HubNode:
					pass
		
		connection_list.append(new_connection)
		root.visual_editor.connect_node(from_node, from_port, to_node, to_port)


func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var connection_reference: Array = [from_node, from_port, to_node, to_port]
	#for i in connection_list:
	#	if i == [from_node, from_port, to_node, to_port]:
	#		connection_list.erase(i)
	connection_list.erase(connection_reference)
	root.visual_editor.disconnect_node(from_node, from_port, to_node, to_port)
