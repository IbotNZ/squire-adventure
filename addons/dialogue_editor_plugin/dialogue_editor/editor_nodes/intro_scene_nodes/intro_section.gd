@tool
extends VisualEditorNode
class_name IntroSectionNode

signal choice_deleted(hub: IntroSection, index: int)

@export var node_resource: IntroSection
const new_choice_position: int = -2
const choice_holder_scene := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/intro_scene_nodes/intro_choice_holder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func sync_choices():
	var new_choice_list: Array[IntroChoiceHolder]
	for i in node_resource.choice_list:
		var new_choice: IntroChoiceHolder = choice_holder_scene.instantiate()
		new_choice.delete_request.connect(on_choice_delete_request)
		new_choice.node_resource = i
		#add_child(new_choice)
		new_choice_list.append(new_choice)
	for i in new_choice_list:
		var move_index = get_child_count() - 2
		add_child(i)
		move_child(i, move_index)
		set_slot(move_index, false, 0, Color("White"), true, 0, Color("White"))


func _on_add_choice_button_pressed() -> void:
	var new_choice = choice_holder_scene.instantiate()
	add_child(new_choice)
	move_child(new_choice, new_choice_position)
	set_slot(get_child_count() - 3, false, 0, Color("white"), true, 0, Color("white"))
	new_choice.delete_request.connect(on_choice_delete_request)
	
	var new_choice_resource := DialogueChoice.new()
	new_choice.node_resource = new_choice_resource
	node_resource.choice_list.append(new_choice_resource)
	new_choice_resource.choice_port = new_choice.get_index()


func on_choice_delete_request(target_node: Node):
	var target_index = target_node.get_index()
	target_node.queue_free()
	node_resource.choice_list.erase(target_node.node_resource)
	set_slot(get_child_count() - 3, false, 0, Color("white"), false, 0, Color("white"))
	choice_deleted.emit(node_resource, target_index)


func _on_dragged(from: Vector2, to: Vector2) -> void:
	node_resource.graph_position = to