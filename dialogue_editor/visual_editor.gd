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

@onready var r_click_menu := $"../RightClickMenu"

var dialogue_scene := preload("res://dialogue_editor/dialogue_text.tscn")
var hub_scene := preload("res://dialogue_editor/dialogue_hub.tscn")
var logic_scene := preload("res://dialogue_editor/dialogue_logic.tscn")
var variable_scene := preload("res://dialogue_editor/dialogue_variable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("Right Click"):
		r_click_menu.position = get_local_mouse_position()
		r_click_menu.show()


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


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var removed_connection := Connection.new(from_node, from_port, to_node, to_port)
	for i in connection_list:
		if i.from_node == removed_connection and i.from_port == removed_connection.from_port and i.to_node == removed_connection.to_node and i.to_port == removed_connection.to_port:
			connection_list.erase(i)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for i in nodes:
		for g in get_children():
			if i == g.name:
				g.queue_free()


func _on_right_click_menu_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var new_node: GraphNode
	match index:
		0: # Dialogue
			new_node = dialogue_scene.instantiate()
			new_node.node_type_changed.connect(_on_dialogue_node_type_changed)
			add_child(new_node)
		1: # Hub
			new_node = hub_scene.instantiate()
			new_node.choice_removed.connect(_on_dialogue_hub_choice_removed)
			add_child(new_node)
		2: # Logic
			new_node = logic_scene.instantiate()
			add_child(new_node)
		3: # Variable
			new_node = variable_scene.instantiate()
			add_child(new_node)
	new_node.position_offset = (get_local_mouse_position() + scroll_offset) / zoom
	r_click_menu.hide()
	r_click_menu.deselect_all()


func _on_dialogue_node_type_changed(node_changed: GraphNode, changed_to: int):
	# Erase now invalid node connections
	var erase_list: Array[Connection]
	match changed_to:
		node_changed.default:
			pass
		node_changed.exposition:
			for i in connection_list:
				if i.from_node == node_changed.name:
					disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
					erase_list.append(i)
		node_changed.start:
			for i in connection_list:
				if i.to_node == node_changed.name:
					disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
					erase_list.append(i)
		node_changed.end:
			for i in connection_list:
				if i.from_node == node_changed.name:
					disconnect_node(i.from_node,i.from_port,i.to_node,i.to_port)
					erase_list.append(i)
	for i in erase_list:
		connection_list.erase(i)
