@tool
extends VisualEditorNode
class_name StartNode

@export var node_resource: DialogueStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dragged.connect(_on_dragged)


func _on_dragged(from: Vector2, to: Vector2):
	node_resource.graph_position = to
	node_edited.emit(self, node_resource)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
