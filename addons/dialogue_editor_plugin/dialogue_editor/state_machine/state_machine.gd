@tool
extends Node

# The point is to make new scene types with unique logic easier to make
# So state machine will handle inputs that should work differently depending on the scene
# Commented functions are ones that may not need unique logic to work

# Scene references should be stored in root
# Even if logic differs same nodes can be reused by different scene types
# The standard paragraph node will likely be reused for example

# Variable editor should get it's own state

@onready var root: DialogueEditor = $".."
@onready var linear_scene_state := $LinearSceneState
@onready var intro_scene_state := $IntroSceneState


# Handles input
func on_input(event: InputEvent):
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.on_input(event)
			1: # Intro Scene
				intro_scene_state.on_input(event)


# Takes dialogue resources from manager and creates the editor nodes that represent them
func sync_editor():
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.sync_editor()
			1: # Intro Scene
				intro_scene_state.sync_editor()


# On right click show the appropriate menu to create new nodes from
func show_right_click_menu(location: Vector2):
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.show_right_click_menu(location)
			1: # Intro Scene
				intro_scene_state.show_right_click_menu(location)


# Delete selected nodes may not need unique logic depending on state
func delete_selected_nodes(nodes: Array[StringName]):
	match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.delete_selected_nodes(nodes)
			1: # Intro Scene
				intro_scene_state.delete_selected_nodes(nodes)
	


# Is there connection conflict

# Get connection

# Get visual editor node
# Get visual editor node resource


# Takes connection and applies the necessary changes to resources
# Also removes conflicting connections. One from port can only have one connection.
func connect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.connect_editor_node(from_node,from_port,to_node,to_port)
			1: # Intro Scene
				intro_scene_state.connect_editor_node(from_node,from_port,to_node,to_port)


# May not be necessary but good to keep in same script as function to connect nodes
func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.disconnect_editor_node(from_node,from_port,to_node,to_port)
			1: # Intro Scene
				intro_scene_state.disconnect_editor_node(from_node,from_port,to_node,to_port)


# As different menus will be used between scenes unique logic is necessary
# Connect the signal from the appropriate node on ready
func node_list_menu_clicked(index: int, mouse_button_index: int):
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.node_list_menu_clicked(index, mouse_button_index)
			1: # Intro Scene
				intro_scene_state.node_list_menu_clicked(index, mouse_button_index)


# Could work without state machine but it will prevent an overly long script
func create_dialogue_node(node_type: StringName):
	if root.current_dialogue_manager != null:
		match root.current_dialogue_manager.dialogue_scene_type:
			0: # Linear Scene
				linear_scene_state.create_dialogue_node(node_type)
			1: # Intro Scene
				intro_scene_state.create_dialogue_node(node_type)


# Update global variables
# In general saving resources will likely work without a state machine
# The changes themselves are mande via state machine
