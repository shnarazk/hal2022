extends Spatial

# export(PackedScene) var Event
signal event_happened

# Declare member variables here. Examples:
var period: Array = []
var current = 0
var no_event = {}
var scheduled_event = [
	# 1月
	{ "id": "卒業研究指導", "type": "univ", "hour": 100 },
	no_event,
	no_event,
	no_event, 
	# 4月
	{ "id": "新入生対応", "type": "univ", "hour": 100 },
	{ "id": "新入生対応", "type": "univ", "hour": 100 }, 
	{ "id": "修士論文指導", "type": "univ", "hour": 100 },
	no_event, 
	no_event, 
	# 7月
	no_event,
	no_event, 
	no_event, 
	{ "id": "科研費申請", "type": "univ", "hour": 100},
	no_event,
	{ "id":"修士論文指導", "type": "univ", "hour": 100},
	{ "id":"卒業研究指導", "type": "univ", "hour": 100},
	{ "id":"卒業研究指導", "type": "univ", "hour": 100},
	no_event,
]

var event = [
	no_event,
	{"id": "出張", "type": "", "hour": 20},
	{"id": "論文査読委員", "type":"social", "hour": 50},
	{"id": "海外出張", "type": "special"},
	{"id": "共同研究", "type": "special"},
	{"id": "アカハラ", "type": "special"},
	{"id": "不正行為発覚", "type": "special"}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var AnualEvent = load("Event.tscn")
	for n in range(0, 18):
		var e = AnualEvent.instance()
		e.rotation.y = -n * PI / 9
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
	period[current].select()
	print(">> %s" % (scheduled_event[current] == null))
	if scheduled_event[current] != no_event:
		# print(scheduled_event[current])
		print(scheduled_event[current])
		emit_signal("event_happened", 0, scheduled_event[current])
	else:
		print("special event")
		var nev = event.size()
		var chance = int((rand_range(0, nev + 0.1) * rand_range(0, nev + 0.1)) / nev)
		# print(chance)
		if nev <= chance:
			chance = nev - 1
		if event[chance] != no_event:
			# print(chance)
			print(event[chance])
			emit_signal("event_happened", 1, event[chance])
	return new_year

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

