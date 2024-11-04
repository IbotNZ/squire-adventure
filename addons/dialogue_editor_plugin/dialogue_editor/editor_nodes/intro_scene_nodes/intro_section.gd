@tool
extends VisualEditorNode
class_name IntroSectionNode

signal choice_deleted(hub: IntroSectionNode, index: int)

@export var node_resource: IntroSection
const new_choice_position: int = -2
const choice_holder_scene := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/intro_scene_nodes/intro_choice_holder.tscn")

@onready var section_title_edit: TextEdit = $SectionTitleEdit
@onready var section_description_edit: TextEdit = $SectionDescriptionEdit
@onready var section_text_edit: TextEdit = $SectionTextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func sync_choices():
	section_title_edit.text = node_resource.title_text
	section_description_edit.text = node_resource.title_description
	section_text_edit.text = node_resource.main_text
	
	var new_choice_list: Array[IntroChoiceHolder]
	for i in node_resource.choice_list:
		var new_choice: IntroChoiceHolder = choice_holder_scene.instantiate()
		new_choice.delete_request.connect(on_choice_delete_request)
		new_choice.node_resource = i
		#add_child(new_choice)
		new_choice_list.append(new_choice)
		new_choice.choice_title_edit.text = i.choice_name
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
	choice_deleted.emit(self, target_index)


func _on_dragged(from: Vector2, to: Vector2) -> void:
	node_resource.graph_position = to


func _on_section_title_edit_text_changed() -> void:
	node_resource.title_text = section_title_edit.text


func _on_section_description_edit_text_changed() -> void:
	node_resource.title_description = section_description_edit.text


func _on_section_text_edit_text_changed() -> void:
	node_resource.main_text = section_text_edit.text
