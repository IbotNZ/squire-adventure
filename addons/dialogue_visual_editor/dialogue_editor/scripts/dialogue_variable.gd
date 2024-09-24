@tool
extends EditorNode

enum {bool_node, number_node}

@onready var type_picker := $OptionButton
@onready var name_picker := $TextEdit
@onready var bool_picker := $DefaultBoolValue
@onready var number_picker := $DefaultNumValue

var var_name: String
var default_bool := false
var default_number := 0
var node_type := bool_node
#var linked_node: DialogueVariable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_offset_changed.connect(_on_editor_node_offset_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	default_bool = linked_node.default_bool
	default_number = linked_node.default_number
	node_type = linked_node.node_type
	var_name = linked_node.var_name
	
	name_picker.text = var_name
	bool_picker.button_pressed = default_bool
	number_picker.value = default_number
	type_picker.selected = node_type


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
