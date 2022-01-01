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
	null,
	{ "id": "1月大学入試監督にあたりました。", "effect": [{ "type": "private_hour_tmp", "value": 20} ] },
	{ "id": "2月学位諮問会の準備をしました。", "effect": [{ "type": "private_hour_tmp", "value": 10} ] },
	null,
	# 4月
	{ "id": "4月卒論生を受け入れました", "effect": [{ "type": "student_hour_year", "value": 20 }, { "type": "number_of_student", "value": 2 }] },
	{ "id": "5月卒論生を受け入れました", "effect": [{ "type": "student_hour_year", "value": 20 }, { "type": "number_of_student", "value": 2 }] },
	null,
	{ "id": "6月ポスドクの採用を考えています。", "optional": true, "effect": [{ "type": "postdoc_hour_year", "value": 40 }, { "type": "number_of_postdoc", "value": 1 }] },
	null,
	# 7月
	null,
	{ "id": "7月大学院入試問題の作成委員を担当しました。","effect": [{ "type": "private_hour_tmp", "value": 20} ],
		"require": "not_abroad"
	},
	null,
	{ "id": "10月科研費Cの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 50}, { "type": "apply_kaken", "wait": 7, "year": 2, "money": 2 } ], "require": "not_applied" },
	{ "id": "10月科研費Aの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 50}, { "type": "apply_kaken", "wait": 8, "year": 3, "money": 10 } ], "require": "not_applied"},
	{ "id": "10月大学入試問題の作成委員になりました。", "effect": [{ "type": "private_hour_tmp", "value": 50} ],
		"require": "not_abroad"
	},
	null,
	{ "id": "12月ポスドク採用", "optional": true, "effect": [{ "type": "postdoc_hour_year", "value": 50 }, { "type": "number_of_postdoc", "value": 1 }] },
	null,
	]

var my_event = [
	null,
	{ "id": "打ち合わせのため国内出張しました。", "optional": true, "effect":[{ "type": "private_hour_tmp", "value": 40}],
		"require": "not_abroad"
	},
	{ "id": "地元中小企業との共同研究を受け入れました。", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 2 }] },
	{ "id": "海外出張に行きました。", "effect":[{ "type": "private_hour_tmp", "value": 100}],
		"require": "not_abroad"
	},
	#{ "id": "共同研究", "type": "univ", "hour": 20 },
	#{ "id": "国際会議実行委員", "type": "univ", "hour": 20 },
	{ "id": "休日出勤を考えています。", "optional": true, "effect":[{ "type": "university_hour_tmp", "value": -80}] },
	{ "id": "体調不良で病院に行きました。", "effect": [{ "type": "university_hour_tmp", "value": 100 } ] },
	{ "id": "研究室でのアカハラに対応しました。", "effect":[{"type": "university_hour_tmp", "value": 400 }] },
	{ "id": "共同研究者の論文不正が発覚しました。", "effect":[{"type": "game_over", "image": null }]},
]

func _init():
	scheduled_event = my_scheduled_event
	event = my_event
	event_type = my_event_type
