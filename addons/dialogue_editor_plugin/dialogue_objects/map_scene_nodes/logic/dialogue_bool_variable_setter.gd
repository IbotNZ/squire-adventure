extends DialogueType
class_name DialogueBoolSetter

var linked_variable: DialogueBoolVariable

func set_var_value(new_value: bool):
	linked_variable.variable_value = new_value
