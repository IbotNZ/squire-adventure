extends Area3D


@onready var animation_player := $AnimationPlayer
@onready var choice_box := $VBoxContainer

var the_camera: Camera3D
var is_mouse_on_figure: bool = false
var is_mouse_on_menu: bool = false


signal figure_selected(figure_position: Vector3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if choice_box.visible:
		var ui_position = the_camera.unproject_position(position)
		choice_box.set_position(Vector2(ui_position.x - choice_box.size.x / 2, ui_position.y - choice_box.size.y))


func _mouse_enter() -> void:
	animation_player.play("Hover")
	is_mouse_on_figure = true


func _mouse_exit() -> void:
	# To prevent playing backwards in full when moving mouse in and out too fast
	await get_tree().physics_frame
	animation_player.play_backwards("Hover")
	is_mouse_on_figure = false


func _input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	the_camera = camera
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var ui_position = camera.unproject_position(position)
			choice_box.set_position(Vector2(ui_position.x - choice_box.size.x / 2, ui_position.y - choice_box.size.y))
			choice_box.show()
			figure_selected.emit(position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not (is_mouse_on_figure or is_mouse_on_menu):
		if event.button_index == MOUSE_BUTTON_LEFT:
			choice_box.hide()


func _on_v_box_container_mouse_entered() -> void:
	is_mouse_on_menu = true


func _on_v_box_container_mouse_exited() -> void:
	is_mouse_on_menu = false
