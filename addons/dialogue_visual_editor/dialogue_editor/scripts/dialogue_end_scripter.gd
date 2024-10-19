@tool
extends EditorNode

# the dialogue that will be set visible when dialogue end runs
# var new_visible_dialogues
@onready @export var button_scripter := $ButtonScripter
@onready @export var assign_button := $ButtonScripter/NewButtonSetter
@onready @export var button_picker_dialog := $ButtonPickerDialog
@onready @export var button_list := $ButtonPickerDialog/ItemList
@onready @export var button_selectable_setter := $ButtonScripter/IsButtonSelectableSetter
var button_list_references: Array

@onready @export var mode_selector := $ModeSelector

@onready @export var variable_picker_dialog := $VariablePickerDialog
@onready @export var variable_scripter := $VariableScripter
@onready @export var variable_selector := $VariableScripter/VariableSetter
@onready @export var variable_bool_setter := $VariableScripter/IsVariableTrue
@onready @export var variable_list: ItemList
var variable_list_references: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_script_mode(mode_selector.selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	if linked_node != null:
		if linked_node.new_visible_dialogue != null:
			assign_button.text = linked_node.new_visible_dialogue.button_title
		if linked_node.selected_variable != null:
			variable_selector.text = linked_node.selected_variable.var_name
		button_selectable_setter.toggle_mode = linked_node.is_dialogue_available
		variable_bool_setter.toggle_mode = linked_node.bool_value_change


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


func _on_mode_selector_item_selected(index: int) -> void:
	switch_script_mode(index)


func switch_script_mode(index: int):
	if linked_node != null:
		linked_node.script_state = index
	button_scripter.hide()
	variable_scripter.hide()
	match index:
		0: # Button Select
			button_scripter.show()
		1: # Variable Select
			variable_scripter.show()


func _on_variable_setter_pressed() -> void:
	variable_list.clear()
	variable_list_references.clear()
	for i in EditorInterface.get_edited_scene_root().get_children():
		if i is DialogueManager:
			for dialogue_node in i.Dialogue_Node_list:
				if dialogue_node is DialogueVariable:
					variable_list.add_item(dialogue_node.var_name)
					variable_list_references.append(dialogue_node)
	variable_picker_dialog.popup()


func _on_is_variable_true_toggled(toggled_on: bool) -> void:
	linked_node.bool_value_change = toggled_on


func _on_variable_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var selected_item = variable_list_references[index]
	variable_selector.text = linked_node.selected_variable.var_name
	linked_node.selected_variable = selected_item
