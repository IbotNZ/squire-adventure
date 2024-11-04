@tool
extends VisualEditorNode
class_name IntroStartNode

@export var node_resource: IntroStart


func _on_dragged(from: Vector2, to: Vector2) -> void:
	node_resource.graph_position = to
