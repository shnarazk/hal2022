extends Spatial

# export(PackedScene) var Event

# Declare member variables here. Examples:
var events: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var AnualEvent = load("AnnualEvent.tscn")
	for n in range(0, 18):
		var e = AnualEvent.instance()
		e.rotation.y = 20 * n
		add_child(e)
		events.push_back(e)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
