@tool
extends Node

@onready var root := $"../.."

# Handles input
func on_input(event: InputEvent):
	pass


# Takes dialogue resources from manager and creates the editor nodes that represent them
func sync_editor():
	pass


# On right click show the appropriate menu to create new nodes from
func show_right_click_menu():
	pass


# Takes connection and applies the necessary changes to resources
# Also removes conflicting connections. One from port can only have one connection.
func connect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass


# May not be necessary but good to keep in same script as function to connect nodes
func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass


# Connect the signal from the appropriate node on ready
func node_list_menu_clicked(index: int, mouse_button_index: int):
	pass


# Could work without state machine but it will prevent an overly long script
func create_dialogue_node(node_type: StringName, graph_edit: GraphEdit):
	pass
