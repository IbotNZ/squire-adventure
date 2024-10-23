extends VisualEditorNode
class_name BoolVarSetterNode

@export var node_resource: DialogueBoolSetter
@onready var variable_setter := $VariableSetter
@onready var variable_select_dialog := $VariableSelectDialog
@onready var variable_list := $VariableSelectDialog/VariableList

var selectable_variable_list: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	if node_resource != null:
		match index:
			0: # True
				node_resource.change_bool_to_value = true
			1: # False
				node_resource.change_bool_to_value = false


func _on_variable_setter_pressed() -> void:
	variable_list.clear()
	selectable_variable_list.clear()
	for i in global_variables.stored_variables:
		if i is DialogueBoolVariable:
			variable_list.add_item(i.variable_name)
			selectable_variable_list.append(i)
	variable_select_dialog.popup()


func _on_variable_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		node_resource.linked_variable = selectable_variable_list[index]
