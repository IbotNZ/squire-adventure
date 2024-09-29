extends Button
class_name FigureButton

signal figure_button_pressed(button_reference: FigureButton, linked_node: DialogueNode)
var linked_node: DialogueNode

func _pressed() -> void:
	figure_button_pressed.emit(self, linked_node)
