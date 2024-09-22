extends Button

signal choice_pressed(node_reference)

var connected_node: DialogueType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	choice_pressed.emit(connected_node)
