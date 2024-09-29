@tool
extends EditorNode

# Match to option button indexes
enum {default, exposition, start, end}

const port_color := Color('White')
var current_type := default
@onready @export var assign_button := $Button
@onready @export var option_button := $OptionButton
@onready @export var text_box := $TextEdit
@onready @export var button_picker: AcceptDialog
@onready @export var button_list: ItemList
@onready @export var button_title: TextEdit
@onready @export var is_selectable: CheckButton

var selected_figure: Area3D
var button_list_references: Array[Node3D]

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
	button_title.text = linked_node.button_title
	is_selectable.button_pressed = linked_node.button_selectable
	set_ports()


func set_ports():
	assign_button.hide()
	button_title.hide()
	is_selectable.hide()
	match current_type:
		default:
			set_slot(0, true, 0, port_color, true, 0, port_color)
			size.y = 0
		exposition:
			set_slot(0, true, 0, port_color, false, 0, port_color)
			size.y = 0
		start:
			set_slot(0, false, 0, port_color, true, 0, port_color)
			assign_button.show()
			button_title.show()
			is_selectable.show()
		end:
			set_slot(0, true, 0, port_color, false, 0, port_color)
	# If changing from start disconnect it's connection to any figures
	if selected_figure != null and current_type != start:
		selected_figure.active_choices.erase(linked_node)


func _on_option_button_item_selected(index: int) -> void:
	current_type = index
	set_ports()
	node_type_changed.emit(self, current_type)
	linked_node.node_type = current_type


#func _on_position_offset_changed() -> void:
#	linked_node.graph_position = position_offset


func _on_text_edit_text_changed() -> void:
	linked_node.text = text_box.text


func _on_button_pressed() -> void:
	button_list.clear()
	button_list_references.clear()
	for i in EditorInterface.get_edited_scene_root().get_children():
		if i is Area3D:
			button_list.add_item(i.name)
			button_list_references.append(i)
	button_picker.popup()


func _on_button_title_edit_text_changed() -> void:
	linked_node.button_title = button_title.text


func _on_is_selectable_toggled(toggled_on: bool) -> void:
	linked_node.button_selectable = toggled_on


func is_dialogue_node_in_array(figure_choice):
	return figure_choice == linked_node


func _on_item_list_item_selected(index: int) -> void:
	selected_figure = button_list_references[index]
	var figure_node_list: Array = selected_figure.active_choices
	if not figure_node_list.any(is_dialogue_node_in_array):
		figure_node_list.append(linked_node)
	button_picker.hide()
