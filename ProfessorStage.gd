extends Job
class_name Professor

var my_event_type = [
	"society",
	"wild",
	"private",
	"university",
	"society",
	"chance",
	"wild",
	"money",
	"private",
	"university",
	"wild",
	"money",
	"chance",
	"society",
	"university",
	"wild",
	"private",
	"money"
]

var my_scheduled_event = [
	# 1月
	{ "id": "1月大学入試監督", "type": "univ", "hour": 10 },
	{ "id": "2月学位諮問会", "type": "univ", "hour": 10 },
	{ "id": "3月ポスドク採用", "effect": [{ "type": "hour", "value": 40 }, { "type": "number_of_postdoc", "value": 1 }] },
	null,
	# 4月
	{ "id": "4月卒論生対応", "effect": [{ "type": "hour", "value": 40 }, { "type": "number_of_student", "value": 2 }] },
	{ "id": "5月卒論生対応", "effect": [{ "type": "hour", "value": 40 }, { "type": "number_of_student", "value": 2 }] },
	null,
	null,
	null,
	# 7月
	null,
	{ "id": "7月大学院入試問題作成委員", "type": "univ", "hour": 30 },
	null,
	{ "id": "10月科研費申請", "type": "univ", "hour": 100 },
	null,
	{ "id": "10月大学入試問題作成委員", "type": "univ", "hour": 200 },
	null,
	{ "id": "12月ポスドク採用", "effect": [{ "type": "hour", "value": 40 }, { "type": "number_of_postdoc", "value": 1 }] },
	null,
	]

var my_event = [
	null,
	{ "id": "出張", "type": "univ", "hour": 20 },
	{ "id": "論文査読委員", "type": "univ", "hour": 20 },
	{ "id": "海外出張", "type": "univ", "hour": 20 },
	{ "id": "共同研究", "type": "univ", "hour": 20 },
	{ "id": "国際会議実行委員", "type": "univ", "hour": 20 },
	{ "id": "体調不良", "type": "univ", "hour": 200 },
	{ "id": "アカハラ", "type": "univ", "hour": 400 },
	{ "id": "論文不正発覚", "type": "special", "image": null }
]

func _init():
	scheduled_event = my_scheduled_event
	event = my_event
	event_type = my_event_type
