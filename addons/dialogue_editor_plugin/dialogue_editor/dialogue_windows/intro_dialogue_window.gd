@tool
extends Control
class_name IntroDialogueWindow

# Nodes used
# IntroStart
# ParagraphNode
# ChoiceHub
# IntroEnd


@onready var root := $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_input():
	match root.dialogue_scene_type:
		0: # Linear Scene
			pass
		1: # Intro Scene
			pass


func run_node(new_node: DialogueType):
	var previous_node: DialogueType = root.current_node
	root.current_node = new_node
	if new_node is IntroStart:
		run_intro_start()
	elif new_node is IntroEnd:
		run_intro_end()
	elif new_node is IntroSection:
		if previous_node is IntroStart:
			run_intro_section(true)
		else:
			run_intro_section(false)


func run_intro_start():
	var node: IntroStart
	run_node(node)


func run_intro_end():
	pass


func run_intro_section(is_previous_node_start: bool):
	# Play animation to switch out sections
	# Set the section text
	# Set the section choices
	root.current_node = root.current_node.next_node
	
	# If previous node was start then just go straight to the new section
	pass


func swap_intro_section():
	# Called after animation is halfway done and new section is 
	pass


func run_variable_setter():
	pass
