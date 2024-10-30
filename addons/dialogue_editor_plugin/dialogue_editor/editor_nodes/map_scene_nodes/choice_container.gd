@tool
extends HBoxContainer
class_name ChoiceContainer

var node_reference: DialogueChoice

@onready var choice_text: TextEdit = $ChoiceText
var port_position: int

signal title_changed(new_text: String, choice_container: ChoiceContainer)
signal deletion_request(node_to_delete: ChoiceContainer)


func _on_choice_text_text_changed() -> void:
	node_reference.choice_name = choice_text.text
	title_changed.emit(choice_text.text, self)


func _on_choice_remove_button_pressed() -> void:
	deletion_request.emit(self)
