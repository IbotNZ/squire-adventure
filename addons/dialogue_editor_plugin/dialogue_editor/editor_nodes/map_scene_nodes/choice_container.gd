@tool
extends HBoxContainer
class_name ChoiceContainer

var node_reference: DialogueChoice

@onready var choice_text := $ChoiceText
var port_position: int

signal title_changed(new_text: String, choice_container: ChoiceContainer)
signal deletion_request(node_to_delete: ChoiceContainer)


func _on_choice_text_text_changed() -> void:
	title_changed.emit(choice_text.text, self)


func _on_choice_remove_button_pressed() -> void:
	deletion_request.emit(self)
