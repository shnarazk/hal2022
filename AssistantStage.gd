extends Job
class_name Assistant

var my_event_type = [
	"chance",
	"university",
	"money",
	"wild",
	"society",
	"chance",
	"private",
	"university",
	"society",
	"university",
	"wild",
	"money",
	"chance",
	"wild",
	"society",
	"private",
	"money",
	"private"
]

var my_scheduled_event = [
	# 1月
	{ "id": "1月卒業研究指導", "effect": [{"type": "univesity_hour_tmp", "value": 100}],  "require": "has_student" },
	null,
	null,
	null,
	# 4月
	{ "id": "4月卒論生受け入れ", "effect": [{ "type": "student_hour_year", "value": 25 }, { "type": "number_of_student", "value": 1 }] },
	{ "id": "5月卒論生受け入れ", "effect": [{ "type": "student_hour_year", "value": 15 }, { "type": "number_of_student", "value": 1 }] },
	{ "id": "6月修士論文指導", "type": "univ", "hour": 100 },
	null,
	null,
	# 7月
	null,
	null,
	null,
	{ "id": "10月科研費申請", "effect": [{ "type": "private_hour_tmp", "value": 100} ] },
	null,
	{ "id":"11月修士論文指導", "effect":[{"type": "student_hour_tmp", "value": 100}], "require": "has_student" },
	{ "id":"12月卒業研究指導", "effect":[{"type": "student_hour_tmp", "value": 100}], "require": "has_student" },
	{ "id":"12月卒業研究指導", "effect":[{"type": "student_hour_tmp", "value": 100}], "require": "has_student" },
	null,
]

var my_event = [
	null,
	{ "id": "出張", "effect":[{ "type": "private_hour_tmp", "value": 40}] },
	{ "id": "論文査読委員", "effect":[ {"type":"society_hour_tmp", "value": 50}] },
	{ "id": "海外出張", "effect":[{ "type": "private_hour_tmp", "value": 120}] },
	{ "id": "共同研究", "type": "special"},
	{ "id": "アカハラ", "type": "special"},
	{ "id": "論文不正発覚", "type": "special", "image": null },
]

func _init():
	scheduled_event = my_scheduled_event
	event = my_event
	event_type = my_event_type
