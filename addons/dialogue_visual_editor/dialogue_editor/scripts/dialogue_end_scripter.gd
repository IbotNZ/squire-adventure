@tool
extends EditorNode

# the dialogue that will be set visible when dialogue end runs
# var new_visible_dialogues
@onready @export var button_picker_dialog := $ButtonPickerDialog
@onready @export var button_list := $ButtonPickerDialog/ItemList
var button_list_references: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_button_setter_pressed() -> void:
	button_list.clear()
	button_list_references.clear()
	for i in EditorInterface.get_edited_scene_root().get_children():
		if i is Area3D:
			for dialogue in i.active_choices:
				button_list.add_item(dialogue.name)
				button_list_references.append(dialogue)
	button_picker_dialog.popup()
