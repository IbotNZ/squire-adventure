extends Resource
class_name DialogueChoice

# Text for the choice button
@export var label: String
# What node will run when the choice is pressed
@export var next_node: DialogueType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
