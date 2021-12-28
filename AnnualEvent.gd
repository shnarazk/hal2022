extends Spatial

export var event_kind = "aa"
var radius = 1.5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cell.translation.x = radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
