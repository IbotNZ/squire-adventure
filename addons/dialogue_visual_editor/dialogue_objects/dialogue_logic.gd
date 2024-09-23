extends DialogueType
class_name DialogueLogic

# Decides what type of variable to check in dialogue manager
enum {local_var, character_stat, character_trait}

# For selecting what variable to check
var local_value_name: String
var local_value: bool = true
var node_type := local_var

# For storing what trait should be checked if the option is selected
var char_stat_to_check
var char_trait_to_check

# Node connections for either logic outcome
var node_connection_for_true: DialogueType
var node_connection_for_false: DialogueType

func check_local_value() -> bool:
	# Since there is only one scene planned for the demo local variables are really all that's needed.
	return local_value

func check_character_stat() -> bool:
	return true


func  check_character_trait() -> bool:
	# Check character trait and see if it matches what it should be
	# Character traits are enums with multiple values
	#return character_trait == enum_val
	return true