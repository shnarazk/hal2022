extends Spatial

# export(PackedScene) var Event
signal event_happened

# Declare member variables here. Examples:
var period: Array = []
var current = 0
var no_event = {}
var scheduled_event = [
	# 1月
	{ "id": "大学入試監督", "type": "univ", "hour": 10 },
	{ "id": "学位諮問会", "type": "univ", "hour": 10 },
	no_event,
	no_event,
	# 4月
	no_event,
	no_event,
	no_event,
	no_event,
	no_event,
	# 7月
	no_event,
	{ "id": "大学院入試問題作成委員", "type": "univ", "hour": 30 },
	no_event,
	{ "id": "科研費申請", "type": "univ", "hour": 100 },
	no_event,
	{ "id": "大学入試問題作成委員", "type": "univ", "hour": 200 },
	no_event,
	no_event,
	no_event,
	]

var event = [
	no_event,
	{ "id": "出張", "type": "univ", "hour": 20 },
	{ "id": "論文査読委員", "type": "univ", "hour": 20 },
	{ "id": "海外出張", "type": "univ", "hour": 20 },
	{ "id": "共同研究", "type": "univ", "hour": 20 },
	{ "id": "国際会議実行委員", "type": "univ", "hour": 20 },
	{ "id": "体調不良", "type": "univ", "hour": 200 },
	{ "id": "アカハラ", "type": "univ", "hour": 400 },
	{ "id": "不正行為発覚", "type": "univ", "hour": 500 },
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
	print("call professor job")
	var new_year = false
	period[current].deselect()
	current += step
	if period.size() <= current:
		current = 0
		new_year = true
	period[current].select()
	if scheduled_event[current] != no_event:
		emit_signal("event_happened", 0, scheduled_event[current])
	else:
		var nev = event.size()
		var chance = int((rand_range(0, nev + 0.1) * rand_range(0, nev + 0.1)) / nev)
		if nev <= chance:
			chance = nev - 1
		# print(chance)
		if event[chance] != no_event:
			emit_signal("event_happened", 1, event[chance])
	return new_year

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
