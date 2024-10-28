extends DialogueType
class_name DialogueHub

class DialogueChoice:
	var choice_name: String
	var choice_port: int
	var connected_node: DialogueType
	
	func _init(name: String, port: int, node: DialogueType) -> void:
		choice_name = name
		choice_port = port

var choice_list: Array[DialogueChoice]


func add_choice(name: String, port: int, node: DialogueType):
	choice_list.append(DialogueChoice.new(name, port, node))
