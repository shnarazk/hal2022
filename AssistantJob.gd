extends Job
class_name Assistant

var my_event_type = [
	"wild",
	"university",
	"money",
	"wild",
	"society",
	"chance",
	"private",
	"wild",
	"society",
	"university",
	"wild",
	"money",
	"chance",
	"wild",
	"society",
	"private",
	"wild",
	"university"
]

var my_scheduled_event = [
	# 1月
	{ "id": "1月卒業研究指導", "type": "univ", "hour": 100 },
	null,
	null,
	null,
	# 4月
	{ "id": "4月新入生対応", "type": "univ", "hour": 100 },
	{ "id": "5月新入生対応", "type": "univ", "hour": 100 },
	{ "id": "6月修士論文指導", "type": "univ", "hour": 100 },
	null,
	null,
	# 7月
	null,
	null,
	null,
	{ "id": "10月科研費申請", "type": "univ", "hour": 100},
	null,
	{ "id":"11月修士論文指導", "type": "univ", "hour": 100},
	{ "id":"12月卒業研究指導", "type": "univ", "hour": 100},
	{ "id":"12月卒業研究指導", "type": "univ", "hour": 100},
	null,
]

var my_event = [
	null,
	{ "id": "出張", "type": "", "hour": 20},
	{ "id": "論文査読委員", "type":"social", "hour": 50},
	{ "id": "海外出張", "type": "special"},
	{ "id": "共同研究", "type": "special"},
	{ "id": "アカハラ", "type": "special"},
	{ "id": "論文不正発覚", "type": "special", "image": null }
]

func _init():
	scheduled_event = my_scheduled_event
	event = my_event
	event_type = my_event_type
