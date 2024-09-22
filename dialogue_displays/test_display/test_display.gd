extends PanelContainer

@onready var text_box := $VBoxContainer/VBoxContainer
@onready var choice_box := $VBoxContainer/VBoxContainer2

var button_scene := preload("res://dialogue_displays/test_display/test_button.tscn")

signal choice_pressed(pressed_button)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func run_dialogue(label: String):
	var new_dialogue = Label.new()
	new_dialogue.text = label
	text_box.add_child(new_dialogue)


func create_choice(label, connected_node):
	var new_choice: Button = button_scene.instantiate()
	new_choice.text = label
	new_choice.connected_node = connected_node
	new_choice.choice_pressed.connect(button_pressed)
	choice_box.add_child(new_choice)


func button_pressed(button_connection):
	choice_pressed.emit(button_connection)


func clear_choices():
	for i in choice_box.get_children():
		i.queue_free()
