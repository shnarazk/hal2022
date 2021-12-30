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

func go_forward(step: int, player, picked_event):
	var new_year = false
	period[current].deselect()
	current += step
	if period.size() <= current:
		current = 0
		new_year = true
	var e = period[current].select()
	print("e: %s, %s" % [e, picked_event == null])
	if picked_event != null and player.check_event_condition(picked_event):
		emit_signal("event_happened", picked_event)
	elif e != null and player.check_event_condition(e):
		emit_signal("event_happened", e)
	else:
		# try again
		e = period[current].select()
		if e != null and player.check_event_condition(e):
			emit_signal("event_happened", e)
		elif period[current].kind == "wild" or period[current].kind == "personal":
			var nev = event.size()
			var chance = int((rand_range(0, nev + 0.1) * rand_range(0, nev + 0.1)) / nev)
			if chance < nev and event[chance] != null and player.check_event_condition(event[chance]):
				emit_signal("event_happened", event[chance])
			elif scheduled_event[current] != null and player.check_event_condition(scheduled_event[current]):
				emit_signal("event_happened", scheduled_event[current])
	return new_year

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
