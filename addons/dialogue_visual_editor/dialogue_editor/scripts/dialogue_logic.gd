@tool
extends EditorNode

@onready var mode_selector := $ModeSelection/ModeSelector
@onready var variable_logic := $VariableLogic
@onready var stat_logic := $StatLogic
@onready var trait_logic := $TraitLogic

enum {variable, character_stat, character_trait}
var logic_type := variable

#var linked_node: DialogueLogic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_offset_changed.connect(_on_editor_node_offset_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	pass


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
