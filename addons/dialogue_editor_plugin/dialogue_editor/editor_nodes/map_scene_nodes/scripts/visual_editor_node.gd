@tool
extends GraphNode
class_name VisualEditorNode

signal node_edited(edited_node: VisualEditorNode, edited_resource: DialogueType)

const global_variables_location := "res://addons/dialogue_editor_plugin/dialogue_objects/variable_nodes/global_variable.tres"
var global_variables := preload(global_variables_location)

func save_change_to_variables(new_resource: GlobalVariable):
	ResourceSaver.save(new_resource, global_variables_location)
