@tool
extends GraphEdit

class Connection:
	var from_node
	var from_port
	var to_node
	var to_port
	
	func _init(origin_node, origin_port, receiving_node, receiving_port) -> void:
		from_node = origin_node
		from_port = origin_port
		to_node = receiving_node
		to_port = receiving_port

var connection_list: Array[Connection]
var current_dialogue_manager: DialogueManager

@onready var r_click_menu := $RightClickMenu

var dialogue_scene := preload("res://addons/dialogue_visual_editor/dialogue_editor/dialogue_text.tscn")
var hub_scene := preload("res://addons/dialogue_visual_editor/dialogue_editor/dialogue_hub.tscn")
var logic_scene := preload("res://addons/dialogue_visual_editor/dialogue_editor/dialogue_logic.tscn")
var variable_scene := preload("res://addons/dialogue_visual_editor/dialogue_editor/dialogue_variable.tscn")
var script_scene := preload("res://addons/dialogue_visual_editor/dialogue_editor/dialogue_end_scripter.tscn")

var is_mouse_on_graph: bool = false
@export @onready var double_click_timer := $Timer
@export var click_rect: Rect2

var is_mouse_on_right_click_menu := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#InputMap.load_from_project_settings()
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			r_click_menu.position = get_local_mouse_position()
			r_click_menu.show()
		if event.button_index == MOUSE_BUTTON_LEFT and not is_mouse_on_right_click_menu:
			r_click_menu.hide()
		if event.button_index == MOUSE_BUTTON_LEFT and is_mouse_on_graph:
			if not double_click_timer.is_stopped():
				var mouse_pos := get_local_mouse_position()
				click_rect.position = Vector2(mouse_pos.x,mouse_pos.y) - (click_rect.size / 2)
				var links_to_remove = get_connections_intersecting_with_rect(click_rect)
				if not links_to_remove.is_empty():
					var link_to_remove = get_closest_connection_at_point(mouse_pos)
					remove_node_connecton(link_to_remove['from_node'],link_to_remove['from_port'],link_to_remove['to_node'],link_to_remove['to_port'])
			double_click_timer.start()


func remove_node_connecton(from_node,from_port,to_node,to_port):
	disconnect_node(from_node,from_port,to_node,to_port)
	#connection_list.erase(Connection.new(from_node,from_port,to_node,to_port))
	# If any connection connect from the same port remove it.
	for i in connection_list:
		if i.from_node == from_node and i.from_port == from_port and i.to_node == to_node and i.to_port == to_port:
			disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
			connection_list.erase(i)
	for i in get_children():
		if i is GraphNode:
			if i.name == from_node:
				if i.linked_node is DialogueNode:
					i.linked_node.next_dialogue_node = null
				elif i.linked_node is DialogueHub:
					for c in i.linked_node.choice_list:
						c.next_node = null
				elif i.linked_node is DialogueLogic:
					if from_port == 0:
						i.linked_node.node_connection_for_true = null
					elif from_port == 1:
						i.linked_node.node_connection_for_false = null
				elif i.linked_node is DialogueVariable:
					pass
				elif i.linked_node is DialogueEndScripter:
					i.linked_node.next_dialogue_node = null


func sync_with_dialogue_manager(resource_list: Array[DialogueType], manager:DialogueManager):
	current_dialogue_manager = manager
	var new_node: GraphNode
	for i in resource_list:
		if i is DialogueNode:
			new_node = dialogue_scene.instantiate()
			new_node.node_type_changed.connect(_on_dialogue_node_type_changed)
		elif i is DialogueHub:
			new_node = hub_scene.instantiate()
			new_node.choice_removed.connect(_on_dialogue_hub_choice_removed)
			#add_child(new_node)
		elif i is DialogueLogic:
			new_node = logic_scene.instantiate()
			new_node.current_dialogue_manager = current_dialogue_manager
		elif i is DialogueVariable:
			new_node = variable_scene.instantiate()
		elif i is DialogueEndScripter:
			new_node = script_scene.instantiate()
		# await Engine.get_main_loop().process_frame
		new_node.linked_node = i
		new_node.position_offset = i.graph_position
		add_child(new_node)
		new_node.sync_with_node()
	# When all nodes have been instantiated create the relevant connections
	await Engine.get_main_loop().process_frame
	for i in get_children():
		if i is GraphNode:
			#i.position_changed.connect(_on_editor_node_dragged)
			if i.linked_node is DialogueNode and i.linked_node.next_dialogue_node:
				connect_node(i.name, 0, find_node_interface(i.linked_node.next_dialogue_node).name, 0)
				connection_list.append(Connection.new(i.name, 0, find_node_interface(i.linked_node.next_dialogue_node).name, 0))
			elif i.linked_node is DialogueHub:
				var hub: DialogueHub = i.linked_node
				for choice in hub.choice_list:
					if choice.next_node != null:
						connect_node(i.name, hub.choice_list.find(choice), find_node_interface(choice.next_node).name, 0)
						connection_list.append(Connection.new(i.name, hub.choice_list.find(choice), find_node_interface(choice.next_node).name, 0))
			elif i.linked_node is DialogueLogic:
				if i.linked_node.node_connection_for_true != null:
					connect_node(i.name, 0, find_node_interface(i.linked_node.node_connection_for_true).name, 0)
					connection_list.append(Connection.new(i.name, 0, find_node_interface(i.linked_node.node_connection_for_true).name, 0))
				if i.linked_node.node_connection_for_false != null:
					connect_node(i.name, 1, find_node_interface(i.linked_node.node_connection_for_false).name, 0)
					connection_list.append(Connection.new(i.name, 1, find_node_interface(i.linked_node.node_connection_for_false).name, 0))
			elif i.linked_node is DialogueVariable:
				pass
			elif i.linked_node is DialogueEndScripter and i.linked_node.next_dialogue_node != null:
				connect_node(i.name, 0, find_node_interface(i.linked_node.next_dialogue_node).name, 0)
				connection_list.append(Connection.new(i.name, 0, find_node_interface(i.linked_node.next_dialogue_node).name, 0))


func _on_editor_node_dragged(from: Vector2, to: Vector2, node_moved: GraphNode):
	node_moved.linked_node.graph_position = to


func find_node_interface(target: DialogueType):
	for i in get_children():
		if i is GraphNode:
			if i.linked_node == target:
				return i


func connection_conflict(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var is_there_conflict: bool = false
	for i in connection_list:
		if i.from_node == from_node and i.from_port == from_port and i.to_node == to_node and i.to_port == to_port:
			is_there_conflict = true
	return is_there_conflict


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var new_connection = Connection.new(from_node,from_port,to_node,to_port)
	if not connection_conflict(from_node,from_port,to_node,to_port):
		# Add connection to array to reference later.
		connection_list.append(new_connection)
		connect_node(from_node,from_port,to_node,to_port)
		
		for i in get_children():
			if i.name == from_node:
				if i.linked_node is DialogueHub:
					for choice in i.get_children():
						if choice.get_index() == from_port + 1:
							for g in get_children():
								if g.name == to_node:
									choice.linked_node.next_node = g.linked_node
				elif i.linked_node is DialogueLogic:
					for g in get_children():
						if g.name == to_node and from_port == 0:
							i.linked_node.node_connection_for_true = g.linked_node
						elif g.name == to_node and from_port == 1:
							i.linked_node.node_connection_for_false = g.linked_node
				elif i.linked_node is DialogueNode:
					for g in get_children():
						if g.name == to_node:
							i.linked_node.next_dialogue_node = g.linked_node
				elif i.linked_node is DialogueEndScripter:
					for g in get_children():
						if g.name == to_node:
							i.linked_node.next_dialogue_node = g.linked_node
	
		# If any connection connect from the same port remove it.
		for i in connection_list:
			if i.from_node == from_node and i.from_port == from_port and i != new_connection:
				disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
				connection_list.erase(i)


func _on_dialogue_hub_choice_removed(node_name: String, connected_port: int) -> void:
	for i in connection_list:
		# When choice is removed disconnect it's connection
		if i.from_node == node_name and i.from_port == connected_port:
			disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
			connection_list.erase(i)
	for i in connection_list:
		# Separate for loop or erasing one just above another connection causes issues
		# If node connection is below the removed choice shift it's connection upwards to remain synced
		if i.from_node == node_name and i.from_port > connected_port:
			disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
			connection_list.erase(i)
			connect_node(i.from_node,i.from_port - 1,i.to_node,i.to_port)
			connection_list.append(Connection.new(i.from_node,i.from_port - 1,i.to_node,i.to_port))


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for i in nodes:
		for g in get_children():
			if i == g.name:
				for c in connection_list:
					if c.from_node == i or c.to_node == i:
						disconnect_node(c.from_node,c.from_port,c.to_node,c.to_port)
				if g.linked_node:
					current_dialogue_manager.Dialogue_Node_list.erase(g.linked_node)
				g.queue_free()


func _on_right_click_menu_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var new_node: EditorNode
	var new_resource: DialogueType
	match index:
		0: # Dialogue
			new_node = dialogue_scene.instantiate()
			new_node.node_type_changed.connect(_on_dialogue_node_type_changed)
			add_child(new_node)
			new_resource = DialogueNode.new()
		1: # Hub
			new_node = hub_scene.instantiate()
			new_node.choice_removed.connect(_on_dialogue_hub_choice_removed)
			new_node.choice_added.connect(_on_dialogue_hub_choice_added)
			add_child(new_node)
			new_resource = DialogueHub.new()
		2: # Logic
			new_node = logic_scene.instantiate()
			add_child(new_node)
			new_resource = DialogueLogic.new()
		3: # Variable
			new_node = variable_scene.instantiate()
			add_child(new_node)
			new_resource = DialogueVariable.new()
		4: # Script
			new_node = script_scene.instantiate()
			add_child(new_node)
			new_resource = DialogueEndScripter.new()
	new_node.linked_node = new_resource
	current_dialogue_manager.Dialogue_Node_list.append(new_resource)
	new_node.position_offset = (get_local_mouse_position() + scroll_offset) / zoom
	r_click_menu.hide()
	r_click_menu.deselect_all()


func _on_dialogue_hub_choice_added(new_choice):
	pass


func _on_dialogue_node_type_changed(node_changed: GraphNode, changed_to: int):
	# Erase now invalid node connections
	var erase_list: Array[Connection]
	match changed_to:
		node_changed.default:
			pass
		node_changed.exposition:
			for i in connection_list:
				if i.from_node == node_changed.name:
					remove_node_connecton(i.from_node,i.from_port,i.to_node,i.to_port)
					#erase_list.append(i)
		node_changed.start:
			for i in connection_list:
				if i.to_node == node_changed.name:
					remove_node_connecton(i.from_node,i.from_port,i.to_node,i.to_port)
					#erase_list.append(i)
		node_changed.end:
			for i in connection_list:
				if i.from_node == node_changed.name:
					remove_node_connecton(i.from_node,i.from_port,i.to_node,i.to_port)
					#erase_list.append(i)
	#for i in erase_list:
	#	connection_list.erase(i)


func _on_mouse_entered() -> void:
	is_mouse_on_graph = true


func _on_mouse_exited() -> void:
	is_mouse_on_graph = false


func _on_right_click_menu_mouse_entered() -> void:
	is_mouse_on_right_click_menu = true


func _on_right_click_menu_mouse_exited() -> void:
	is_mouse_on_right_click_menu = false
