extends Node
class_name DialogueManager

@export var Dialogue_Node_list: Array[DialogueType]

# Store the previous hub so if an exposition node is ran it can return to that hub
var Previous_Choice_Hub: DialogueHub
# The current dialogue node that is to run
var Current_Dialogue_Node: DialogueType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initiate_dialogue_display():
	# Initializes an instance of a dialogue display scene and links it to run dialogue in.
	pass


func run_current_node():
	if Current_Dialogue_Node is DialogueNode:
		run_dialogue_text()
	if Current_Dialogue_Node is DialogueHub:
		run_dialogue_hub()
	if Current_Dialogue_Node is DialogueLogic:
		run_dialogue_logic()


func run_dialogue_text():
	pass


func run_dialogue_hub():
	pass


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
