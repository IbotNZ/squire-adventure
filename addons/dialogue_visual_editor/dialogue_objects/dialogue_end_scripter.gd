extends DialogueType
class_name DialogueEndScripter

enum {button_state, variable_state}

@export var script_state: int = button_state

@export var new_visible_dialogue: DialogueNode
@export var next_dialogue_node: DialogueType
@export var is_dialogue_available: bool = true

@export var selected_variable: DialogueVariable
@export var bool_value_change: bool = true
