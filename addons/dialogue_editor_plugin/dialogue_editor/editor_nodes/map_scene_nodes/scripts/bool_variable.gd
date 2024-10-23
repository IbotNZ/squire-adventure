@tool
extends VisualEditorNode
class_name BoolVariableNode

@export var node_resource: DialogueBoolVariable
@onready var bool_name_text := $BoolVariableName


func _ready() -> void:
	dragged.connect(_on_dragged)


func _on_dragged(from: Vector2, to: Vector2):
	node_resource.graph_position = to
	node_edited.emit(self, node_resource)


func _on_bool_variable_name_text_changed() -> void:
	print(node_resource)
	node_resource.variable_name = bool_name_text.text
	node_edited.emit(self, node_resource)


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: # True
			node_resource.variable_value = true
		1: # False
			node_resource.variable_value = false
	node_edited.emit(self, node_resource)
