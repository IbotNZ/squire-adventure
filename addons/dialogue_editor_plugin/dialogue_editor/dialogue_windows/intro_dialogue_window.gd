@tool
extends Control
class_name IntroDialogueWindow

# Nodes used
# IntroStart
# ParagraphNode
# ChoiceHub
# IntroEnd

# When running a section node set this value and the animation will switch to
# it halfway through it's animation
var new_section: IntroSection
var section_transition_player := $SectionTransitionPlayer

var choice_ref_array: Array[DialogueType]

@onready var title := $ScrollContainer/DialogueWindow/VBoxContainer2/TitleRow/HBoxContainer/TitleLabel
@onready var description := $ScrollContainer/DialogueWindow/VBoxContainer2/TitleRow/HBoxContainer/DescriptionLabel
@onready var main_text := $ScrollContainer/DialogueWindow/VBoxContainer2/MainTextRow/RichTextLabel
@onready var choice_list := $ScrollContainer/DialogueWindow/VBoxContainer2/ChoiceRow/ChoiceList

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
	var end_node: IntroEnd = root.current_node
	get_tree().change_scene_to_file(end_node.next_scene)


func run_intro_section(is_previous_node_start: bool):
	new_section = root.current_node.next_node
	# Play animation to switch out sections
	# Set the section text
	# Set the section choices
	section_transition_player.play("swap_in_section")
	
	# If previous node was start then just go straight to the new section


func swap_intro_section():
	if new_section != null:
		# Called after animation is halfway done
		# New text values
		title.text = new_section.title_text
		description.text = new_section.title_description
		main_text.text = new_section.main_text
		
		# Remove previous choices
		choice_ref_array.clear()
		choice_list.clear()
		
		# Replace with new choices
		for i in new_section.choice_list:
			choice_ref_array.append(i.connected_node)
			choice_list.add_item(i.choice_name)


func run_variable_setter():
	pass
