extends Spatial

export var event_kind = "aa"
var active = false
var radius = 1.5
var basic_material = load("BasicEvent.tres")
var advanced_material = load("AdvancedEvent.tres")

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
	$Cell/MeshInstance.set_surface_material(0, basic_material)
	# $Cell/MeshInstance.set_surface_material(0, advanced_material)
	$Cell.translation.x = radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		$Cell.rotate_z(0.5 * delta)

func upgrade():
	$Cell/MeshInstance.set_surface_material(0, advanced_material)
	print("called")
	pass
