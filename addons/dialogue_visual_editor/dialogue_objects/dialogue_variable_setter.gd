extends DialogueType
class_name DialogueVariableSetter

# The variable that will be changed when this node is run
var selected_variable: DialogueVariable
var next_node: DialogueType

# Changing local variables
var bool_change_value: bool
var number_change_value: float

# Changing global variables
var stat_change_value: float
var trait_change_value
