extends Node3D

var mouse_motion: Vector3
var lerp_motion: Vector3 = Vector3()
@export var mouse_sensitivity := 0.25
@export var scroll_sensitivity := 0.75

@onready var camera_y_gimble := $"."
@onready var camera_x_gimble := $InnerGimble
@onready var camera_spring := $InnerGimble/SpringArm3D
@onready var camera := $InnerGimble/SpringArm3D/Camera3D


var spring_aim := 8.0

const SELECT_SPEED := 0.5
const PAN_SPEED := 5.0
const MAX_ZOOM: float = 12
const MIN_ZOOM: float = 4

var target_positon: Vector3
var move_to_target := false
var can_move := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_move:
		position = position.lerp(lerp_motion, delta * PAN_SPEED)
	#camera_spring.spring_length = camera_spring.spring_length.lerp()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			mouse_motion = Vector3()
			mouse_motion.x = event.relative.x * mouse_sensitivity
			mouse_motion.z = event.relative.y * mouse_sensitivity
			lerp_motion = position + mouse_motion.rotated(Vector3.UP, deg_to_rad(rotation_degrees.y))
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_aim -= scroll_sensitivity
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_aim += scroll_sensitivity
		#tween.interpolate_value(camera_spring.spring_length, spring_aim, )
		spring_aim = clamp(spring_aim, MIN_ZOOM, MAX_ZOOM)
		var tween = create_tween()
		tween.tween_property(camera_spring, "spring_length", spring_aim, .2)


func _on_location_figure_figure_selected(figure_position: Vector3) -> void:
	#can_move = false
	var tween = create_tween()
	#tween.finished.connect()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", figure_position, SELECT_SPEED)
	lerp_motion = figure_position

func _on_tween_finished():
	can_move = true
