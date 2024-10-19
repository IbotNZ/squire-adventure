extends DialogueType
class_name  DialogueStart

# The node that will display a button to start this dialogue
# Note replace with a specific node class when it is made
var linked_dialogue_container: Node

# Title that the button will display
var title: String

# Whether the option is available from the start without any conditions
var is_selectable: bool = false
