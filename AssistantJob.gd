extends Spatial

# export(PackedScene) var Event
signal event_happened

# Declare member variables here. Examples:
var period: Array = []
var current = 0
var scheduled_event = [
	# 1月
	"卒業研究指導", 
	"",
	"",
	"", 
	# 4月
	'新入生対応', 
	"新入生対応", 
	"修士論文指導", 
	"", 
	"", 
	# 7月
	"",
	"", 
	"", 
	"科研費申請",
	"",
	"修士論文指導",
	"卒業研究指導",
	"卒業研究指導",
	"",
	]

var event = [
	"", "出張", "論文査読委員", "海外出張", "共同研究", "アカハラ", "不正行為発覚"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var AnualEvent = load("AnnualEvent.tscn")
	for n in range(0, 18):
		var e = AnualEvent.instance()
		e.rotation.y = n * PI / 9
		add_child(e)
		period.push_back(e)
	period[current].active = true
	
func go_forward(step: int):
	period[current].deselect()
	current = (current + step) % period.size()
	period[current].select()
	if scheduled_event[current] != "":
		emit_signal("event_happened", 0, scheduled_event[current])
	else:
		var nev = event.size()
		var chance = int((rand_range(0, nev + 0.1) * rand_range(0, nev + 0.1)) / nev)
		print(chance)
		if event[chance] != "":
			emit_signal("event_happened", 1, event[chance])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

