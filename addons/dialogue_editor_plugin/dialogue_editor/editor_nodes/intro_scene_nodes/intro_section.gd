extends VisualEditorNode

const new_choice_position: int = -2
const choice_holder_scene := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/intro_scene_nodes/intro_choice_holder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_choice_button_pressed() -> void:
	var new_choice = choice_holder_scene.instantiate()
	add_child(new_choice)
	move_child(new_choice, new_choice_position)
	set_slot(get_child_count() - 1, false, 0, Color("white"), true, 0, Color("white"))
