extends GraphNode
class_name EditorNode

signal position_changed(from, to, self_reference)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dragged(from: Vector2, to: Vector2) -> void:
	position_changed.emit(from, to, self)
