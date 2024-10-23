extends VisualEditorNode
class_name ParagraphNode

@export var node_resource: DialogueNode
@onready var paragraph_text := $ParagraphText

func _on_paragraph_text_text_changed() -> void:
	node_resource.display_text = paragraph_text.text
	node_edited.emit()
