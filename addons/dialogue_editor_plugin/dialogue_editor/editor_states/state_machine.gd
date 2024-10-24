@tool
extends Node

@onready var root: DialogueEditor = $".."
@onready var linear_scene_state := $LinearScene

func _ready() -> void:
	pass

func on_input(event: InputEvent):
	match root.current_dialogue_manager.dialogue_scene_type:
		0: # Linear Scene
			linear_scene_state.on_input(event)


func sync_visual_editor(dialogue_manager: DialogueManager):
	#linear_scene_state = $LinearScene
	match dialogue_manager.dialogue_scene_type:
		0: # Linear Scene
			linear_scene_state.sync_visual_editor(dialogue_manager)
