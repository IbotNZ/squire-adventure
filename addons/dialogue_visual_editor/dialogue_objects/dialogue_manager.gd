extends Node
class_name DialogueManager

var Test_Display = preload("res://addons/dialogue_visual_editor/dialogue_displays/test_display/test_display.tscn")

@export var Dialogue_Node_list: Array[DialogueType]

# Store the previous hub so if an exposition node is ran it can return to that hub
var Previous_Choice_Hub: DialogueHub
# The current dialogue node that is to run
var Current_Dialogue_Node: DialogueType

# Stores the currently instantiated dialogue display
var Current_Dialogue_Display: Control

# List of effects to run when dialogue ends
var Dialogue_End_List: Array[DialogueEndScripter]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#initiate_dialogue_display()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initiate_dialogue_display():
	# Initializes an instance of a dialogue display scene and links it to run dialogue in.
	var New_Display = Test_Display.instantiate()
	New_Display.choice_pressed.connect(choice_has_been_pressed)
	Current_Dialogue_Display = New_Display
	add_child(New_Display)


func choice_has_been_pressed(button_connection):
	Current_Dialogue_Display.clear_choices()
	Current_Dialogue_Node = button_connection
	run_current_node()


func run_current_node():
	if Current_Dialogue_Node is DialogueNode:
		run_dialogue_text()
	elif Current_Dialogue_Node is DialogueHub:
		run_dialogue_hub()
	elif Current_Dialogue_Node is DialogueLogic:
		run_dialogue_logic()
	elif Current_Dialogue_Node is DialogueEndScripter:
		run_dialogue_end_scripter()


func run_dialogue_end_scripter():
	var dialogue_script: DialogueEndScripter = Current_Dialogue_Node
	Dialogue_End_List.append(dialogue_script)
	Current_Dialogue_Node = Current_Dialogue_Node.next_dialogue_node
	run_current_node()


func run_dialogue_text():
	var text_node: DialogueNode = Current_Dialogue_Node
	Current_Dialogue_Display.run_dialogue(text_node.text)
	match text_node.node_type:
		text_node.default:
			Current_Dialogue_Node = text_node.next_dialogue_node
			run_current_node()
		text_node.exposition:
			Current_Dialogue_Node = Previous_Choice_Hub
			run_current_node()
		text_node.start:
			Current_Dialogue_Node.button_selectable = false
			Current_Dialogue_Node = text_node.next_dialogue_node
			run_current_node()
		text_node.end:
			run_dialogue_end()


func run_dialogue_end():
	for i in Dialogue_End_List:
		if i.new_visible_dialogue != null:
			i.new_visible_dialogue.button_selectable = i.is_dialogue_available
	Dialogue_End_List.clear()
	Current_Dialogue_Display.queue_free()


func run_dialogue_hub():
	Previous_Choice_Hub = Current_Dialogue_Node
	var hub_node: DialogueHub = Current_Dialogue_Node
	for i in hub_node.choice_list:
		Current_Dialogue_Display.create_choice(i.label, i.next_node)


func run_dialogue_logic():
	var running_node: DialogueLogic = Current_Dialogue_Node
	var return_val: bool
	match running_node.node_type:
		running_node.local_var:
			return_val = running_node.check_local_value()
		running_node.character_stat:
			return_val = running_node.check_character_stat()
		running_node.character_trait:
			return_val = running_node.check_character_trait()
	if return_val:
		Current_Dialogue_Node = running_node.node_connection_for_true
	else:
		Current_Dialogue_Node = running_node.node_connection_for_false
	run_current_node()
