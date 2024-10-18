@tool
extends EditorNode

# the dialogue that will be set visible when dialogue end runs
# var new_visible_dialogues
@onready @export var assign_button := $NewButtonSetter
@onready @export var button_picker_dialog := $ButtonPickerDialog
@onready @export var button_list := $ButtonPickerDialog/ItemList
@onready @export var button_selectable_setter := $IsButtonSelectableSetter
var button_list_references: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	if linked_node != null:
		assign_button.text = linked_node.new_visible_dialogue.button_title
		button_selectable_setter.toggle_mode = linked_node.is_dialogue_available


func _on_new_button_setter_pressed() -> void:
	button_list.clear()
	button_list_references.clear()
	for i in EditorInterface.get_edited_scene_root().get_children():
		if i is Area3D:
			for dialogue in i.active_choices:
				if dialogue != null:
					button_list.add_item(dialogue.button_title)
					button_list_references.append(dialogue)
	button_picker_dialog.popup()


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var selected_item = button_list_references[index]
	assign_button.text = button_list.get_item_text(index)
	linked_node.new_visible_dialogue = selected_item

func _on_position_offset_changed() -> void:
	linked_node.graph_position = position_offset


func _on_is_button_selectable_setter_toggled(toggled_on: bool) -> void:
	linked_node.is_dialogue_available = toggled_on
