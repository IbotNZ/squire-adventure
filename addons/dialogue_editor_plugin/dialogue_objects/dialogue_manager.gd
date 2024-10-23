extends Node
class_name DialogueManager

# The manager for processing dialogue node functions

const global_variables_location := "res://addons/dialogue_editor_plugin/dialogue_objects/variable_nodes/global_variable.tres"
var save_game_location: String
var global_variables := preload(global_variables_location)

var dialogue_list: Array[DialogueType]
var current_node: DialogueType
# For exposition node
var most_recent_hub: DialogueHub

enum state {dialogue, logic}
var game_state: int

func _input(event: InputEvent) -> void:
	if game_state == state.dialogue:
		if event.is_action_pressed("ui_accept"):
			# Run next node
			pass

func run_node(new_node: DialogueType):
	current_node = new_node
	if current_node is DialogueNode:
		pass
	elif current_node is DialogueExposition:
		pass
	elif current_node is DialogueHub:
		pass
	elif current_node is DialogueStart:
		pass
	elif current_node is DialogueEnd:
		pass
	elif current_node is DialogueBoolSetter:
		pass
	elif current_node is DialogueBoolLogic:
		pass
	
