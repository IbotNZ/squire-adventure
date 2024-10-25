@tool
extends Node

# The point is to make new scene types with unique logic easier to make
# So state machine will handle inputs that should work differently depending on the scene
# Commented functions are ones that may not need unique logic to work

# Scene references should be stored in root
# Even if logic differs same nodes can be reused by different scene types
# The standard paragraph node will likely be reused for example

# Variable editor should get it's own state

# Handles input
func on_input():
	pass


# Takes dialogue resources from manager and creates the editor nodes that represent them
func sync_editor():
	pass


# On right click show the appropriate menu to create new nodes from
func show_right_click_menu():
	pass


# Delete selected nodes may not need unique logic depending on state

# Is there connection conflict

# Get connection

# Get visual editor node
# Get visual editor node resource


# Takes connection and applies the necessary changes to resources
# Also removes conflicting connections. One from port can only have one connection.
func connect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass


# May not be necessary but good to keep in same script as function to connect nodes
func disconnect_editor_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass


# As different menus will be used between scenes unique logic is necessary
# Connect the signal from the appropriate node on ready
func node_list_menu_clicked(index: int, mouse_button_index: int):
	pass


# Could work without state machine but it will prevent an overly long script
func create_dialogue_node(node_type: StringName, graph_edit: GraphEdit):
	pass


# Update global variables
# In general saving resources will likely work without a state machine
# The changes themselves are mande via state machine
