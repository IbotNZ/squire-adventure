@tool
extends VisualEditorNode
class_name IntroEndNode

@export var node_resource: IntroEnd


func _on_dragged(from: Vector2, to: Vector2) -> void:
	node_resource.graph_position = to
