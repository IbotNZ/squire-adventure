@tool
extends DialogueType
class_name DialogueHub

class DialogueChoice:
	var choice_name: String
	var choice_port: int
	var connected_node: DialogueType
	
	func _init(name: String, port: int, node: DialogueType) -> void:
		choice_name = name
		choice_port = port
		connected_node = node

var choice_list: Array[DialogueChoice]


func add_choice(name: String, port: int, node: DialogueType):
	choice_list.append(DialogueChoice.new(name, port, node))


func get_choices() -> Array[Array]:
	var choice_array: Array[Array]
	
	for i in choice_list:
		choice_array.append([i.choice_name,i.choice_port,i.connected_node])
	
	return choice_array
