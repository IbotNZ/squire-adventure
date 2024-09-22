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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
