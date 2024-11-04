@tool
extends Node
class_name DialogueManager

# The manager for processing dialogue node functions

@export_enum("Linear Scene", "Intro Scene") var dialogue_scene_type = 0

const global_variables_location := "res://addons/dialogue_editor_plugin/dialogue_objects/variable_nodes/global_variable.tres"
var save_game_location: String
var global_variables := preload(global_variables_location)

@export var dialogue_list: Array[DialogueType]
@export var current_node: DialogueType
# For exposition node
#var most_recent_hub: DialogueHub

#enum state {dialogue, logic, hub}
#var game_state: int

@onready var intro_dialogue_window := $IntroDialogueWindow


func _ready() -> void:
	intro_dialogue_window.on_ready()


func _input(event: InputEvent) -> void:
	intro_dialogue_window.on_input()
	#if game_state == state.dialogue:
	#	if event.is_action_pressed("ui_accept"):
	#		# Run next node
	#		run_node(current_node.next_node)

#func run_node(new_node: DialogueType):
#	current_node = new_node
#	if current_node is DialogueNode:
#		run_paragraph()
#	elif current_node is DialogueExposition:
#		run_exposition()
#	elif current_node is DialogueHub:
#		run_hub()
#	elif current_node is DialogueStart:
#		run_start()
#	elif current_node is DialogueEnd:
#		run_end()
#	elif current_node is DialogueBoolSetter:
#		run_bool_setter()
#	elif current_node is DialogueBoolLogic:
#		run_bool_logic()

#func run_paragraph():
#	print("Paragraph")
#	game_state = state.dialogue


#func run_exposition():
#	print("Exposition")
#	game_state = state.dialogue


#func run_start():
#	print("Start")
#	run_node(current_node.next_node)


#func run_end():
#	print("End")


#func run_bool_setter():
#	print("Bool Setter")
#	game_state = state.logic
#	run_node(current_node.next_node)


#func run_bool_logic():
#	print("Bool Logic")
#	game_state = state.logic
#	run_node(current_node.next_node)


#func run_hub():
#	print("Hub")
#	game_state = state.hub
