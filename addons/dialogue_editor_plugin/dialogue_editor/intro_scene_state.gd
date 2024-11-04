@tool
extends Node


@onready var root: DialogueEditor = $"../.."
@onready var right_click_menu: ItemList = $"../../IntroNodeList"

var is_mouse_on_menu: bool
var right_click_menu_location: Vector2

var connection_list: Array

const LINK_CORRECTION := -7
const SLOT_CORRECTION := 7


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
	connection_list.clear()
	var new_editor_node: VisualEditorNode
	for i in root.current_dialogue_manager.dialogue_list:
		if i is IntroSection:
			new_editor_node = root.intro_section_node.instantiate()
		elif i is IntroStart:
			new_editor_node = root.intro_start_node.instantiate()
		elif i is IntroEnd:
			new_editor_node = root.intro_end_node.instantiate()
		new_editor_node.node_resource = i
		new_editor_node.position_offset = i.graph_position
		root.visual_editor.add_child(new_editor_node)
	
	await Engine.get_main_loop().process_frame
	# Sync editor node connections
	for i in root.visual_editor.get_children():
		if i is VisualEditorNode:
			var target = root.get_visual_editor_resource_connection(i.node_resource.next_node)
			# Some nodes need custom logic
			if i is IntroSectionNode:
				i.choice_deleted.connect(on_hub_choice_deleted)
				var choice_counter: int = 1
				i.sync_choices()
				for choice: DialogueChoice in i.node_resource.choice_list:
					if choice.connected_node != null:
						var choice_target = root.get_visual_editor_resource_connection(choice.connected_node)
						#print(choice.choice_port)
						root.visual_editor.connect_node(i.name, choice.choice_port + LINK_CORRECTION, choice_target.name, 0)
			else:
				if i.node_resource.next_node != null:
					connect_editor_node(i.name, 0, target.name, 0)


func on_hub_choice_deleted(hub: IntroSectionNode, index: int):
	var ports_to_change: Array[Array]
	var choices_to_change: Array
	print("Index " + str(index))
	for i in connection_list:
		if i[0] == hub.name and i[1] == index + LINK_CORRECTION:
			disconnect_editor_node(i[0], i[1], i[2], i[3])
		elif i[0] == hub.name and i[1] > index + LINK_CORRECTION:
			i[1] -= 1
	
	for i in hub.node_resource.choice_list:
		if i.choice_port > index:
			i.choice_port -= 1


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
		for i in connection_list: # Searching list with a filter lambda function would likely be more performant
			if i[0] == from_node and i[1] == from_port:
				disconnect_editor_node(i[0], i[1], i[2], i[3])
		
		for i in root.visual_editor.get_children():
			if i.name == from_node:
				var next_node_resource: Resource = root.get_visual_editor_node_resource(to_node)
				if i is IntroStartNode:
					i.node_resource.next_node = root.get_visual_editor_node_resource(to_node)
				if i is IntroEndNode:
					pass
				if i is IntroSectionNode:
					for choice in i.node_resource.choice_list:
						#print(choice.choice_port)
						#print(from_port + 6)
						#print(" ")
						if choice.choice_port == from_port + 5:
							choice.connected_node = next_node_resource
		
		connection_list.append(new_connection)
		
		root.visual_editor.connect_node(from_node, from_port, to_node, to_port)


# May not be necessary but good to keep in same script as function to connect nodes
func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	connection_list.erase([from_node, from_port, to_node, to_port])
	root.visual_editor.disconnect_node(from_node, from_port, to_node, to_port)
	
	# Will have to add logic for node types that don't have just one connection port
	var from_node_reference = root.get_visual_editor_node(from_node)
	var from_node_resource = root.get_visual_editor_node_resource(from_node)
	if from_node_resource is IntroSection:
		for i in from_node_resource.choice_list:
			if i.choice_port == from_port + 5:
				i.connected_node = null
	else:
		from_node_resource.next_node = null


func delete_selected_nodes(nodes: Array[StringName]):
	for i in root.visual_editor.get_children():
		if nodes.has(i.name):
			for connection in connection_list:
				if connection[0] == i.name or connection[2] == i.name:
					connection_list.erase(connection)
			
			# Should defer to state machine to handle multiple node types being checked for ports
			for dialogue in root.current_dialogue_manager.dialogue_list:
				if dialogue is IntroSection:
					for choice: DialogueChoice in dialogue.choice_list:
						if choice.connected_node == i.node_resource:
							choice.connected_node = null
				else:
					if dialogue.next_node == i.node_resource:
						dialogue.next_node = null
			root.current_dialogue_manager.dialogue_list.erase(i.node_resource)
			i.queue_free()


# Connect the signal from the appropriate node on ready
func node_list_menu_clicked(index: int, mouse_button_index: int):
	match index:
		0: # Section
			create_dialogue_node("intro_section_node")
		1: # Start
			create_dialogue_node("intro_start_node")
		2: # End
			create_dialogue_node("intro_end_node")
	#visual_editor.add_child(new_editor_node)
	#new_editor_node.position_offset = right_click_menu_location
	right_click_menu.hide()


# Could work without state machine but it will prevent an overly long script
func create_dialogue_node(node_type: StringName):
	var new_editor_node: VisualEditorNode
	var new_dialogue_resource: DialogueType
	
	match node_type:
		"intro_start_node":
			new_editor_node = root.intro_start_node.instantiate()
			new_dialogue_resource = IntroStart.new()
			new_editor_node.node_resource = new_dialogue_resource
		"intro_end_node":
			new_editor_node = root.intro_end_node.instantiate()
			new_dialogue_resource = IntroEnd.new()
			new_editor_node.node_resource = new_dialogue_resource
		"intro_section_node":
			new_editor_node = root.intro_section_node.instantiate()
			new_dialogue_resource = IntroSection.new()
			new_editor_node.node_resource = new_dialogue_resource
			new_editor_node.choice_deleted.connect(on_hub_choice_deleted)
	
	new_dialogue_resource.graph_position = right_click_menu_location
	root.visual_editor.add_child(new_editor_node)
	
	new_editor_node.position_offset = right_click_menu_location
	root.current_dialogue_manager.dialogue_list.append(new_dialogue_resource)
