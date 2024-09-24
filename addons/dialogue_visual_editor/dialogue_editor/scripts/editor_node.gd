@tool
extends GraphNode
class_name EditorNode

#signal position_changed(from, to, self_reference)

var linked_node: DialogueType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#position_offset_changed.connect(_on_position_offset_changed)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_editor_node_offset_changed() -> void:
	linked_node.graph_position = position_offset
