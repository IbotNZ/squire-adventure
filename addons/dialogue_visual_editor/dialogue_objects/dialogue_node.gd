extends DialogueType
class_name DialogueNode

# Types of dialogue node behaviour
enum {default, start, end, exposition}

var text: String
var node_type := default

# References for default node
var next_dialogue_node: DialogueType

# References for start node
var start_button: Node

# References for end node
var end_button: Node
