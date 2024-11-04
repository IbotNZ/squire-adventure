@tool
extends HBoxContainer
class_name IntroChoiceHolder

signal delete_request(target_node: Node)

@export var node_resource: DialogueChoice
@export @onready var choice_title_edit := $ChoiceTitleEdit


func _on_choice_title_edit_text_changed() -> void:
	node_resource.choice_name = choice_title_edit.text


func _on_delete_choice_button_pressed() -> void:
	delete_request.emit(self)


func set_resource(new_resource: DialogueChoice):
	node_resource = new_resource
