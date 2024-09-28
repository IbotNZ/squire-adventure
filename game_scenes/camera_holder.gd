extends Node3D

@onready var camera := $Camera3D
var pan_camera := false
var pan_to: Vector3
const PAN_SPEED := 6.0

var mouse_motion_x
var mouse_motion_y
var mouse_motion: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			mouse_motion = Vector3()
			mouse_motion.x = event.relative.x * 0.2
			mouse_motion.z = event.relative.y * 0.2
			position += mouse_motion.rotated(Vector3.UP, deg_to_rad(rotation_degrees.y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if pan_camera:
		position = position.lerp(pan_to, delta * PAN_SPEED)
		if position.distance_to(pan_to) < .1:
			pan_camera = false


func pan_camera_to(new_position: Vector3):
	pan_to = new_position
	pan_camera = true


func _on_button_holder_camera_pan_request(new_position: Vector3) -> void:
	pan_camera_to(new_position)
