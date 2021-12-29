extends Spatial

# export var event_kind = "aa"
var active = false
var radius = 1.5
var basic_material = load("art/BasicEvent.tres")
var advanced_material = load("art/AdvancedEvent.tres")
var chance_material = load("art/chanceColor.tres")
var money_material = load("art/moneyColor.tres")
var private_material = load("art/privateColor.tres")
var society_material = load("art/societyColor.tres")
var university_material = load("art/universityColor.tres")
var wild_material = load("art/wildColor.tres")

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
		$Cell.rotate_z(0.5 * delta)

func upgrade():
	$Cell/MeshInstance.set_surface_material(0, advanced_material)
	pass

func set_kind(type):
	match type:
		"chance": $Cell/MeshInstance.set_surface_material(0, chance_material)
		"money": $Cell/MeshInstance.set_surface_material(0, money_material)
		"private": $Cell/MeshInstance.set_surface_material(0, private_material)
		"society": $Cell/MeshInstance.set_surface_material(0, society_material)
		"university": $Cell/MeshInstance.set_surface_material(0, university_material)
		"wild": $Cell/MeshInstance.set_surface_material(0, wild_material)
		_: print("error")
