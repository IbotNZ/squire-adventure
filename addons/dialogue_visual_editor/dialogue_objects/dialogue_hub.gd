extends DialogueType
class_name DialogueHub

# Represents data stored for choice buttons
class Dialogue_Choice:
	# Text for the choice button
	var label: String
	# What node will run when the choice is pressed
	var next_node: DialogueType

# List of choices that will be used to fill the dialogue hub
var choice_list: Array[Dialogue_Choice]

func create_choice(button_label: String, button_next_node: DialogueType):
	var new_choice = Dialogue_Choice.new()
	new_choice.label = button_label
	new_choice.next_node = button_next_node
	choice_list.append(new_choice)
