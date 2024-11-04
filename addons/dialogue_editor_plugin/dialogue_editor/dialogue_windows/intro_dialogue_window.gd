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
@onready var section_transition_player := $SectionTransitionPlayer

var choice_ref_array: Array[DialogueType]

@onready var title := $ScrollContainer/DialogueWindow/VBoxContainer2/TitleRow/HBoxContainer/TitleLabel
@onready var description := $ScrollContainer/DialogueWindow/VBoxContainer2/TitleRow/HBoxContainer/DescriptionLabel
@onready var main_text := $ScrollContainer/DialogueWindow/VBoxContainer2/MainTextRow/RichTextLabel
@onready var choice_list := $ScrollContainer/DialogueWindow/VBoxContainer2/ChoiceRow/ChoiceList

@onready var root := $".."

# Called when the node enters the scene tree for the first time.
func on_ready() -> void:
	var start_node: IntroStart
	for i in root.dialogue_list:
		if i is IntroStart:
			start_node = i
	if start_node != null:
		run_node(start_node)


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
	var node: IntroStart = root.current_node
	run_node(node.next_node)


func run_intro_end():
	var end_node: IntroEnd = root.current_node
	get_tree().change_scene_to_file(end_node.next_scene)


func run_intro_section(is_previous_node_start: bool):
	new_section = root.current_node
	# Play animation to switch out sections
	# Set the section text
	# Set the section choices
	if is_previous_node_start:
		swap_intro_section()
		section_transition_player.play("swap_in_section")
	else:
		section_transition_player.play("swap_out_section")
	
	# If previous node was start then just go straight to the new section


func swap_intro_section():
	print(new_section)
	#if root.current_node != null:
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


func _on_choice_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		var index_ref := choice_ref_array[index]
		run_node(index_ref)
