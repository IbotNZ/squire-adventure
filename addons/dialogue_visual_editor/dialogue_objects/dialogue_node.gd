extends DialogueType
class_name DialogueNode

# Types of dialogue node behaviour
enum {default, exposition, start, end}

@export var button_title: String = ""
@export var button_description: String = ""
@export var button_selectable: bool

@export var text: String = ""
@export var node_type: int = default

# References for default node
@export var next_dialogue_node: DialogueType

# References for start node
var start_button: Node

# References for end node
var end_button: Node
