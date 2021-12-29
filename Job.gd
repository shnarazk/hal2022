extends Node
class_name Job

# export(PackedScene) var Event
signal event_happened(event_descriptor)

# Declare member variables here. Examples:
var period: Array = []
var current = 0
var scheduled_event = []
var event = []
var event_type = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var AnualEvent = load("Event.tscn")
	for n in range(0, 18):
		var e = AnualEvent.instance()		
		e.rotation.y = -n * PI / 9
		e.set_kind(event_type[n])
		add_child(e)
		period.push_back(e)
	period[current].active = true

func go_forward(step: int):
	var new_year = false
	period[current].deselect()
	current += step
	if period.size() <= current:
		current = 0
		new_year = true
	var e = period[current].select()
	if e != null:
		# print(e)
		emit_signal("event_happened", e)
	elif scheduled_event[current] != null:
		emit_signal("event_happened", scheduled_event[current])
	else:
		var nev = event.size()
		var chance = int((rand_range(0, nev + 0.1) * rand_range(0, nev + 0.1)) / nev)
		if nev <= chance:
			chance = nev - 1
		# print(chance)
		if event[chance] != null:
			emit_signal("event_happened", event[chance])
	return new_year

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
