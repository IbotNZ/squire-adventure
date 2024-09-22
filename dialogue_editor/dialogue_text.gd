extends GraphNode

# Match to option button indexes
enum {default, exposition, start, end}

const port_color := Color('White')
var current_type := default
@onready var assign_button := $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_ports()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_ports():
	match current_type:
		default:
			set_slot(0, true, 0, port_color, true, 0, port_color)
			assign_button.visible = false
			size.y = 0
		exposition:
			set_slot(0, true, 0, port_color, false, 0, port_color)
			assign_button.visible = false
			size.y = 0
		start:
			set_slot(0, false, 0, port_color, true, 0, port_color)
			assign_button.visible = true
		end:
			set_slot(0, true, 0, port_color, false, 0, port_color)
			assign_button.visible = true
		


func _on_option_button_item_selected(index: int) -> void:
	current_type = index
	set_ports()
