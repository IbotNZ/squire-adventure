@tool
extends HBoxContainer
class_name ChoiceContainer

@onready var choice_text := $ChoiceText
var port_position: int

signal title_changed(new_text: String, index: int)
signal deletion_request(node_to_delete: ChoiceContainer, index: int)


func _on_choice_text_text_changed() -> void:
	title_changed.emit(choice_text.text, port_position)


func _on_choice_remove_button_pressed() -> void:
	deletion_request.emit(self, port_position)
