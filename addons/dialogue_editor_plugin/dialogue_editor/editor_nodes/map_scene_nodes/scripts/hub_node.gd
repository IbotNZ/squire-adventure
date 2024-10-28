@tool
extends VisualEditorNode
class_name HubNode

signal choice_deleted(hub: HubNode, index: int)

@export var node_resource: DialogueHub

const choice_container_scene := preload("res://addons/dialogue_editor_plugin/dialogue_editor/editor_nodes/map_scene_nodes/choice_container.tscn")
const choice_container_start_index: int = 1
var choice_container_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dragged.connect(_on_dragged)


func _on_dragged(from: Vector2, to: Vector2):
	node_resource.graph_position = to
	node_edited.emit(self, node_resource)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_choice_button_pressed() -> void:
	create_new_choice()


func create_new_choice():
	var new_choice: ChoiceContainer = choice_container_scene.instantiate()
	add_child(new_choice)
	# Move new child to start index plus number of objects in node choice list array
	var new_choice_position = node_resource.choice_list.size() + choice_container_start_index
	move_child(new_choice, new_choice_position)
	choice_container_count += 1
	set_slot(new_choice_position, false, 0, Color("White"), true, 0, Color("White"))
	
	new_choice.port_position = new_choice_position
	new_choice.title_changed.connect(on_choice_title_change)
	new_choice.deletion_request.connect(on_choice_deletion_request)
	
	node_resource.add_choice("", new_choice_position, null)


func sync_new_choice(index: int):
	var new_choice: ChoiceContainer = choice_container_scene.instantiate()
	add_child(new_choice)
	# Move new child to start index plus number of objects in node choice list array
	var new_choice_position = index
	move_child(new_choice, new_choice_position)
	choice_container_count += 1
	set_slot(new_choice_position, false, 0, Color("White"), true, 0, Color("White"))
	
	new_choice.port_position = new_choice_position
	new_choice.title_changed.connect(on_choice_title_change)
	new_choice.deletion_request.connect(on_choice_deletion_request)


func on_choice_title_change(new_text: String, choice_container: ChoiceContainer):
	var index := choice_container.get_index()
	for i in node_resource.choice_list:
		if i.choice_port == index:
			i.choice_name = new_text


# When a choice is deleted the main scene should shuffle connections below it on index upwards
func on_choice_deletion_request(node_to_delete: ChoiceContainer):
	var index := node_to_delete.get_index()
	for i in node_resource.choice_list:
		#print(i.choice_port)
		#print(index)
		#print(i.choice_port)
		if i.choice_port == index:
			clear_slot(node_resource.choice_list.size())
			node_resource.choice_list.erase(i)
	node_to_delete.queue_free()
	choice_container_count -= 1
	
	choice_deleted.emit(self, index - 1)
