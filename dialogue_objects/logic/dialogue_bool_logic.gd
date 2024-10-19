extends DialogueType
class_name DialogueBoolLogic

var linked_variable: DialogueBoolVariable

var node_connection_for_false: DialogueType

func get_var_value():
	return linked_variable.variable_value
