@tool
extends EditorNode

@onready var mode_selector := $ModeSelection/ModeSelector
@onready var variable_selector := $VariableSelection/VariableSelector
@onready var variable_logic := $VariableLogic
@onready var stat_logic := $StatLogic
@onready var trait_logic := $TraitLogic

enum {variable, character_stat, character_trait}
var logic_type := variable

var current_dialogue_manager: DialogueManager
#var linked_node: DialogueLogic

# The currently selected local variable.
var current_variable: DialogueVariable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_offset_changed.connect(_on_editor_node_offset_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	logic_type = linked_node.node_type
	mode_selector.select(logic_type)
	current_variable = linked_node.local_variable
	if current_variable:
		_on_variable_selector_pressed()
		variable_selector.select(get_variables().find(current_variable))
	select_logic_type()


func is_variable(dialogue_node):
	return dialogue_node is DialogueVariable


func get_variables() -> Array[DialogueType]:
	return current_dialogue_manager.Dialogue_Node_list.filter(is_variable)


func select_logic_type():
	variable_logic.visible = false
	stat_logic.visible = false
	trait_logic.visible = false
	match logic_type:
		variable:
			logic_type = variable
			variable_logic.visible = true
		character_stat:
			logic_type = character_stat
			stat_logic.visible = true
		character_trait:
			logic_type = character_trait
			trait_logic.visible = true


func _on_mode_selector_item_selected(index: int) -> void:
	logic_type = index
	select_logic_type()
	linked_node.node_type = logic_type


func _on_var_num_picker_value_changed(value: float) -> void:
	linked_node.var_number = value


func _on_var_stat_picker_value_changed(value: float) -> void:
	linked_node.stat_number = value


func _on_variable_selector_pressed() -> void:
	variable_selector.clear()
	match logic_type:
		variable:
			var all_current_variables = get_variables()
			for i in all_current_variables:
				variable_selector.add_item(i.var_name)
		character_stat:
			pass
		character_trait:
			pass


func _on_variable_selector_item_selected(index: int) -> void:
	match logic_type:
		variable:
			var all_current_variables = get_variables()
			var selected_var_name: String = variable_selector.get_item_text(index)
			for i in all_current_variables:
				if i.var_name == selected_var_name:
					current_variable = i
					linked_node.local_variable = i
		character_stat:
			pass
		character_trait:
			pass
