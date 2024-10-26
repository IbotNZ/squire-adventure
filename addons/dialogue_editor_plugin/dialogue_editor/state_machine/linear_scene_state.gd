@tool
extends Node

@onready var root: DialogueEditor = $"../.."
@onready var right_click_menu: ItemList = $"../../MapSceneNodeList"

var is_mouse_on_menu: bool
var right_click_menu_location: Vector2

var connection_list: Array


func _ready() -> void:
	right_click_menu.mouse_entered.connect(_on_mouse_enter_right_click_menu)
	right_click_menu.mouse_exited.connect(_on_mouse_exit_right_click_menu)


# Handles input
func on_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		show_right_click_menu(root.get_local_mouse_position())
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and is_mouse_on_menu == false:
		right_click_menu.hide()
		#variable_right_click_menu.hide()
	if event is InputEventMouseButton and event.is_double_click() and event.button_index == MOUSE_BUTTON_LEFT:
		var connection: Dictionary = root.visual_editor.get_closest_connection_at_point(root.get_local_mouse_position())
		if connection.size() > 0:
			disconnect_editor_node(connection.get("from_node"), connection.get("from_port"), connection.get("to_node"), connection.get("to_port"))


func _on_mouse_enter_right_click_menu():
	is_mouse_on_menu = true


func _on_mouse_exit_right_click_menu():
	is_mouse_on_menu = false


# Takes dialogue resources from manager and creates the editor nodes that represent them
func sync_editor():
	pass


# On right click show the appropriate menu to create new nodes from
func show_right_click_menu(location: Vector2):
	right_click_menu_location = (location + root.visual_editor.scroll_offset) / root.visual_editor.zoom
	right_click_menu.position = location
	right_click_menu.deselect_all()
	right_click_menu.show()


# Takes connection and applies the necessary changes to resources
# Also removes conflicting connections. One from port can only have one connection.
func connect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var new_connection := [from_node, from_port, to_node, to_port]
	if not connection_list.has(new_connection):
		print("No connection conflict")
		for i in connection_list: # Searching list with a filter lambda function would likely be more performant
			if i[0] == from_node and i[1] == from_port:
				disconnect_editor_node(i[0], i[1], i[2], i[3])
				#connection_list.erase(i)
		
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


# May not be necessary but good to keep in same script as function to connect nodes
func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	connection_list.erase([from_node, from_port, to_node, to_port])
	root.visual_editor.disconnect_node(from_node, from_port, to_node, to_port)
	
	# Will have to add logic for node types that don't have just one connection port
	var node_resource:DialogueType = root.get_visual_editor_node_resource(from_node)
	node_resource.next_node = null


# Connect the signal from the appropriate node on ready
func node_list_menu_clicked(index: int, mouse_button_index: int):
	match index:
		0: # Paragraph
			create_dialogue_node("paragraph_node")
		1: # Exposition
			create_dialogue_node("exposition_node")
		2: # Hub
			create_dialogue_node("hub_node")
		3: # Start
			create_dialogue_node("start_node")
		4: # End
			create_dialogue_node("end_node")
		5: # Bool Var Setter
			create_dialogue_node("bool_var_setter_node")
		6: # Bool Logic
			create_dialogue_node("bool_logic_node")
	#visual_editor.add_child(new_editor_node)
	#new_editor_node.position_offset = right_click_menu_location
	right_click_menu.hide()


# Could work without state machine but it will prevent an overly long script
func create_dialogue_node(node_type: StringName):
	var new_editor_node: VisualEditorNode
	var new_dialogue_resource: DialogueType
	
	match node_type:
		"bool_variable_node":
			new_editor_node = root.bool_variable_node.instantiate()
			new_dialogue_resource = DialogueBoolVariable.new()
			new_editor_node.node_resource = new_dialogue_resource
		"bool_logic_node":
			new_editor_node = root.bool_logic_node.instantiate()
			new_dialogue_resource = DialogueBoolLogic.new()
			new_editor_node.node_resource = new_dialogue_resource
		"bool_var_setter_node":
			new_editor_node = root.bool_logic_node.instantiate()
			new_dialogue_resource = DialogueBoolSetter.new()
			new_editor_node.node_resource = new_dialogue_resource
		"start_node":
			new_editor_node = root.start_node.instantiate()
			new_dialogue_resource = DialogueStart.new()
			new_editor_node.node_resource = new_dialogue_resource
		"end_node":
			new_editor_node = root.end_node.instantiate()
			new_dialogue_resource = DialogueEnd.new()
			new_editor_node.node_resource = new_dialogue_resource
		"paragraph_node":
			new_editor_node = root.paragraph_node.instantiate()
			new_dialogue_resource = DialogueNode.new()
			new_editor_node.node_resource = new_dialogue_resource
		"exposition_node":
			new_editor_node = root.exposition_node.instantiate()
			new_dialogue_resource = DialogueExposition.new()
			new_editor_node.node_resource = new_dialogue_resource
		"hub_node":
			new_editor_node = root.hub_node.instantiate()
			new_dialogue_resource = DialogueHub.new()
			new_editor_node.node_resource = new_dialogue_resource
		
	
	root.visual_editor.add_child(new_editor_node)
	#new_editor_node.node_edited.connect(_on_editor_node_changed)
	
	
	
	#if root.current_dialogue_manager != null:
	new_editor_node.position_offset = right_click_menu_location
	root.current_dialogue_manager.dialogue_list.append(new_dialogue_resource)
	#elif editor_mode == mode.variable_editor:
	#	new_editor_node.position_offset = right_click_variable_menu_location
	#	new_editor_node.node_edited.connect(_on_editor_node_changed)
	#	global_variables.stored_variables.append(new_dialogue_resource)
	#	update_global_variables()
