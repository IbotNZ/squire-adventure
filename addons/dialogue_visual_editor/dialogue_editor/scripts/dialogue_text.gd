@tool
extends EditorNode

# Match to option button indexes
enum {default, exposition, start, end}

const port_color := Color('White')
var current_type := default
@onready @export var assign_button := $Button
@onready @export var option_button := $OptionButton
@onready @export var text_box := $TextEdit

signal node_type_changed(self_reference, new_type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_ports()
	position_offset_changed.connect(_on_editor_node_offset_changed)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	text_box.text = linked_node.text
	option_button.select(linked_node.node_type)
	current_type = linked_node.node_type
	set_ports()


func set_ports():
	match current_type:
		default:
			set_slot(0, true, 0, port_color, true, 0, port_color)
			assign_button.visible = false
			size.y = 0
		exposition:
			set_slot(0, true, 0, port_color, false, 0, port_color)
			assign_button.visible = false
			size.y = 0
		start:
			set_slot(0, false, 0, port_color, true, 0, port_color)
			assign_button.visible = true
		end:
			set_slot(0, true, 0, port_color, false, 0, port_color)
			assign_button.visible = true
		


func _on_option_button_item_selected(index: int) -> void:
	current_type = index
	set_ports()
	node_type_changed.emit(self, current_type)


#func _on_position_offset_changed() -> void:
#	linked_node.graph_position = position_offset
