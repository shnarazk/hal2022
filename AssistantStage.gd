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
	"money",
	"wild",
	"private",
	"chance",
	"university",
	"society",
	"wild",
	"money",
	"private"
]

var my_scheduled_event = [
	# 1月
	{ "id": "1月卒業研究の指導をしました。", "effect": [{"type": "university_hour_tmp", "value": 100}],  "require": "has_student" },
	null,
	null,
	null,
	# 4月
	{ "id": "4月卒論生を受け入れました。", "effect": [{ "type": "student_hour_year", "value": 25 }, { "type": "number_of_student", "value": 1 }] },
	{ "id": "5月卒論生を受け入れました。",
		"optional": true,
		"effect": [{ "type": "student_hour_year", "value": 15 }, { "type": "number_of_student", "value": 1 }]
	},
	{ "id": "6月修士論文指導", "type": "univ", "hour": 100 },
	null,
	null,
	# 7月
	null,
	null,
	null,
	{ "id": "10月科研費Cの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 2, "money": 1 } ], "require": "not_applied"},
	{ "id": "10月科研費Aの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 3, "money": 10 } ], "require": "not_applied"},
	{ "id": "11月修士論文の指導をしました。", "effect":[{"type": "student_hour_tmp", "value": 100}], "require": "has_student" },
	{ "id": "12月卒業研究の指導をしました。", "effect":[{"type": "student_hour_tmp", "value": 100}], "require": "has_student" },
	{ "id": "12月卒業研究の指導をしました。", "effect":[{"type": "student_hour_tmp", "value": 100}], "require": "has_student" },
	null,
]

var my_event = [
	null,
	{ "id": "出張を考えています。", "optional": true, "effect":[{ "type": "private_hour_tmp", "value": 40}] },
	{ "id": "論文査読の依頼がありました。", "optional": true, "effect":[ {"type":"society_hour_tmp", "value": 50}], "decilne": [{ "type": "society_point", "value": -1 }]},
	{ "id": "海外出張を考えています。", "optional": true, "effect":[{ "type": "private_hour_tmp", "value": 120}] },
	{ "id": "地元中小企業から共同研究の打診がありました。", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 1 }] },
	{ "id": "アカハラに対応しました。", "type": "special"},
	{ "id": "共同研究者の論文不正が発覚しました。", "effect":[ {"type": "scientific misconduct", "image": null }] },
]

func _init():
	scheduled_event = my_scheduled_event
	event = my_event
	event_type = my_event_type
