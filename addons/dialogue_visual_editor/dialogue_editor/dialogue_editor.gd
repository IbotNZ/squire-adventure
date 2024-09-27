@tool
extends Control

var editor_scene := preload("res://addons/dialogue_visual_editor/dialogue_editor/visual_editor.tscn")
@onready var visual_editor := $VisualEditor
var current_dialogue_manager: DialogueManager


func _ready():
	#InputMap.load_from_project_settings()
	pass


func clean_up():
	visual_editor.queue_free()
	visual_editor = editor_scene.instantiate()
	add_child(visual_editor)


func initialize_editor(new_scene_dialogue_manager: DialogueManager):
	current_dialogue_manager = new_scene_dialogue_manager
	visual_editor.sync_with_dialogue_manager(current_dialogue_manager.Dialogue_Node_list, new_scene_dialogue_manager)


func enable_input():
	visual_editor.allow_input = true


func disable_input():
	visual_editor.allow_input = false
