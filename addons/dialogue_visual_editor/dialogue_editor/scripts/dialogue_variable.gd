@tool
extends GraphNode

enum {bool_node, number_node}

@onready var bool_picker := $DefaultBoolValue
@onready var number_picker := $DefaultNumValue
var default_bool := false
var default_number := 0
var node_type := bool_node
var linked_node: DialogueVariable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	pass


func _on_option_button_item_selected(index: int) -> void:
	bool_picker.hide()
	number_picker.hide()
	match index:
		0:
			bool_picker.show()
			node_type = bool_node
		1:
			number_picker.show()
			node_type = number_node
