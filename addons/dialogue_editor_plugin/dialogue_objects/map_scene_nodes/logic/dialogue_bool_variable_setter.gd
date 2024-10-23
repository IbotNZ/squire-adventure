extends DialogueType
class_name DialogueBoolSetter

var linked_variable: DialogueBoolVariable
var change_bool_to_value: bool

func set_var_value(new_value: bool):
	linked_variable.variable_value = new_value
