extends Area3D

@onready var anim_player := $AnimationPlayer
var anim_position: float

@onready var ui_marker := $UIMarker

var test_display := preload("res://addons/dialogue_visual_editor/dialogue_displays/test_display/test_display.tscn")
@onready var OptionList := $LocationDialogueList

signal camera_pan_request(new_position: Vector3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#anim_player.play("hover")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	anim_player.play("Hover")


func _on_mouse_exited() -> void:
	anim_player.play_backwards("Hover")


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var ui_position = camera.unproject_position(ui_marker.position)
			OptionList.set_position(Vector2(ui_position.x - OptionList.size.x / 2, ui_position.y - OptionList.size.y))
			OptionList.show()
			camera_pan_request.emit(position)
