@tool
extends EditorNode

@onready var var_picker := $VariablePicker
@onready var bool_picker := $BoolPickerContainer/BoolValuePicker
@onready var var_change_picker := $VarChangerContainer/VarChangePicker
@onready var stat_change_picker := $StatChangerContainer/StatChangePicker
@onready var trait_change_picker := $TraitSetterContainer/TraitValuePicker

@onready var bool_container := $BoolPickerContainer
@onready var var_changer_container := $VarChangerContainer
@onready var stat_changer_container := $StatChangerContainer
@onready var trait_setter_container := $TraitSetterContainer

#var linked_node: DialogueVariableSetter
var current_dialogue_manager: DialogueManager
var current_variable: DialogueVariable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bool_value_picker_item_selected(index: int) -> void:
	# True
	if index == 0:
		linked_node.bool_change_value = true
	# False
	else:
		linked_node.bool_change_value = false


func _on_var_change_picker_value_changed(value: float) -> void:
	linked_node.number_change_value = value


func is_variable(dialogue_node):
	return dialogue_node is DialogueVariable


func get_variables() -> Array[DialogueType]:
	return current_dialogue_manager.Dialogue_Node_list.filter(is_variable)


func _on_variable_picker_pressed() -> void:
	var_picker.clear()
	for i in get_variables():
		var_picker.add_item(i.var_name)


func _on_variable_picker_item_selected(index: int) -> void:
	var all_current_variables = get_variables()
	var selected_var_name: String = var_picker.get_item_text(index)
	if current_variable is DialogueVariable:
		for i in all_current_variables:
			if i.var_name == selected_var_name:
				current_variable = i
				linked_node.local_variable = i
		bool_container.hide()
		var_changer_container.hide()
		stat_changer_container.hide()
		trait_setter_container.hide()
		if current_variable.node_type == 0: # Bool
			bool_container.show()
			if linked_node.bool_change_value:
				var_picker.select(0)
			else:
				var_picker.select(1)
		elif current_variable.node_type == 1: # Number
			var_changer_container.show()
			var_change_picker.set_value_no_signal(linked_node.number_change_value)
