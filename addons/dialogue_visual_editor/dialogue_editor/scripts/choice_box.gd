@tool
extends HBoxContainer

signal delete_choice_pressed(self_reference)
@onready @export var choice_name_box := $ChoiceName
var linked_node: DialogueChoice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_delete_choice_button_pressed() -> void:
	delete_choice_pressed.emit(self)


func _on_choice_name_text_changed() -> void:
	linked_node.label = choice_name_box.text
