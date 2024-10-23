@tool
extends EditorPlugin


const MainPanel = preload("res://addons/dialogue_editor_plugin/dialogue_editor/dialogue_editor.tscn")

var main_panel_instance

func _enter_tree() -> void:
	scene_changed.connect(_on_scene_changed)
	main_panel_instance = MainPanel.instantiate()
	main_panel_instance.editor_plugin = self
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)
	set_process_input(not Engine.is_editor_hint())

func is_dialogue_manager(node_reference: Node):
	return node_reference is DialogueManager


func _on_scene_changed(scene_root: Node):
	main_panel_instance.clean_up()
	#await Engine.get_main_loop().process_frame
	# If needing to hide editor on scenes with no manager check for any manager and hide editor if false
	#if scene_root:
	#	for i in scene_root.get_children():
	#		if i is DialogueManager:
	#			main_panel_instance.initialize_editor(i)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	#if main_panel_instance:
	#	main_panel_instance.visible = visible
	main_panel_instance.visible = visible


func _get_plugin_name():
	return "Dialogue Editor"


func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
