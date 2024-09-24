@tool
extends EditorNode

var choice_box := preload("res://addons/dialogue_visual_editor/dialogue_editor/choice_box.tscn")
const port_color := Color('White')

var linked_node: DialogueHub

signal choice_removed(node_name: String, connected_port: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sync_with_node():
	var new_choice
	for i in linked_node.choice_list:
		new_choice = choice_box.instantiate()
		new_choice.delete_choice_pressed.connect(_on_delete_choice_button_pressed)
		add_child(new_choice)
		move_child(new_choice, -2)
		set_slot(get_child_count() - 2, false, 0, port_color, true, 0, port_color)
		new_choice.choice_name_box.text = i.label


func clean_port(index: int):
	# The lowest slot will get cleared and connections moved upwards
	clear_slot(get_child_count() - 2)


func _on_add_choice_button_pressed() -> void:
	var new_choice = choice_box.instantiate()
	new_choice.delete_choice_pressed.connect(_on_delete_choice_button_pressed)
	add_child(new_choice)
	move_child(new_choice, -2)
	set_slot(get_child_count() - 2, false, 0, port_color, true, 0, port_color)


func _on_delete_choice_button_pressed(choice_reference: Node) -> void:
	var port_index = choice_reference.get_index()
	clean_port(port_index)
	choice_reference.queue_free()
	choice_removed.emit(name, port_index - 1)
