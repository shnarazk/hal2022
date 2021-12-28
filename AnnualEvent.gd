extends Spatial

export var event_kind = "aa"
var active = false
var radius = 1.5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func select():
	active = true

func deselect():
	$Cell.rotation.z = 0
	active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cell.translation.x = radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		$Cell.rotate_z(0.01)
