extends Spatial

var initialized = false
var active = false
var kind = null
var radius = 1.5
var private_material = load("art/Cell/privateColor.tres")

var events = {
	"chance": [
		{ "id": "特許が成立しました。", "effect": [{ "type": "private_hour_tmp", "value": 20 }, {"type": "money", "value": 0.5}],
			"require": "is_skill_level2"
		},
		null,
		{ "id": "TVで専門家としてコメントしてください。",
			"optional": true,
			"effect": [{ "type": "society_hour_tmp", "value": 10 }, {"type": "contribution_point", "value": 5}, { "type": "money", "value": 0.1 }],
			"require": "is_skill_level3",
		},
		{ "id": "事務員を採用すると雑務が減ります。",
			"optional": true,
			"effect": [{ "type": "university_hour_year", "value": -20 }, {"type": "money", "value": -2}],
		},
		{ "id": "格上の大学に移らないか打診がありました。",
			"optional": true,
			"effect": [ {"type": "new_university"} ],
		},
		{
			"id": "大学入試センターから出題委員の依頼がありました",
			"optional": true,
			"effect": [{ "type": "private_hour_year", "value": 120 }, {"type": "society_point", "value": 10}, {"type": "connection_point", "value": 10}],
			"decline": [],
		},
		{ "id": "国内学会の招待講演を依頼されました。",
			"optional": true,
			"effect": [{ "type": "private_hour_tmp", "value": 20 }, {"type": "society_point", "value": 5}, {"type": "connection_point", "value": 5}],
			"decline": [{"type": "society_point", "value": -2}],
			"require": "is_skill_level3"
		},
		{ "id": "国際会議の招待講演を依頼されました。",
			"optional": true,
			"effect": [{ "type": "private_hour_tmp", "value": 50 }, {"type": "society_point", "value": 10}, {"type": "connection_point", "value": 40}],
			"decline": [{"type": "society_point", "value": -2}],
			"require": "is_skill_level3"
		}
	],
	"money": [
		{ "id": "学内研究補助金を獲得獲得しました", "effect": [{ "type": "money", "value": 10 } ] },
		{ "id": "科研費B申請", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 7, "year": 2, "money": 2 } ], "require": "not_applied" },
		{ "id": "学内研究補助金獲得", "effect": [{ "type": "money", "value": 0.5 } ] },
		null,
		{ "id": "地元中小企業から共同研究を打診されました。", "optional": true, "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 2 }] },
		{ "id": "科研費Cの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 2, "money": 1 } ], "require": "not_applied"},
		{ "id": "科研費Aの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 3, "money": 10 } ], "require": "not_applied"},
		{ "id": "大企業から共同研究を打診されました。", "optional": true, "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 6 }] },
		{ "id": "科研費の共同研究者になりました。", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "kaken_money", "year":2, "money": 1 }], "require": "not_applied" },
		{ "id": "科研費大型プロジェクトが採択されました。", "effect": [{ "type": "private_hour_year", "value": 100 }, { "type": "kaen_money", "year": 2, "money": 5 } ],
			"require": "not_applied"
		},
		{ "id": "経済産業省助成金獲得", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 10 }],
			"require": "is_skill_level3"
		}
	],
	"private": [
		{ "id": "徹夜を考えています。", "optional": true, "effect": [{ "type": "private_hour_tmp", "value": 20 }] },
		{ "id": "学生との打ち合わせをしました。", "effect": [{ "type": "student_hour_tmp", "value": 10 }],
			"require": "has_student"
		},
		{ "id": "ポスドクとの打ち合わせをしました。", "effect": [{ "type": "postdoc_hour_tmp", "value": 20 }],
			"require": "has_postdoc"
		},
		null,
		{ "id": "twitterで炎上しました。", "effect": [{ "type": "private_hour_tmp", "value": 50 }] },
		{ "id": "研究機器が故障しました。", "effect": [{ "type": "money", "value": -1 } ] },
		{ "id": "過労で入院しました。", "effect": [{ "type": "private_hour_year", "value": 200 }, { "type": "university_point", "value": -2}] },
		{ "id": "子供が生まれました。", "effect": [{ "type": "private_hour_year", "value": 100 }], "require": "is_married" },
		{ "id": "結婚を考えています。", "optional": true, "effect": [{ "type": "private_hour_year", "value": 100 }, { "type": "marry" }], "require": "is_not_married" },
		{ "id": "研究の最終段階で追い込みしますか。", "optional": true, "effect": [{ "type": "private_hour_tmp", "value": -50 }] },
		{ "id": "交通事故で入院しました。", "effect": [{ "type": "private_hour_tmp", "value": 200 },  { "type": "university_point", "value": -2}] },
	],
	"society": [
		{ "id": "論文査読の依頼がありました。",
			"optional": true,
			"effect": [{ "type": "society_hour_tmp", "value": 50 }, {"type": "society_point", "value": 5}],
			"decline": [{"type": "society_point", "value": -3}]
		},
		null,
		{ "id": "学会で表彰されました。", "effect": [{ "type": "connection_point", "value": 2}, { "type": "society_point", "value": 3 }]},
		{ "id": "研究会開催を依頼されました。", "effect": [{ "type": "society_hour_tmp", "value": 50 }, {"type": "society_point", "value": 5}]},
		{ "id": "国際大会開催を依頼されました。",
			"optional": true,
			"effect": [{ "type": "society_hour_tmp", "value": 200 }, {"type": "society_point", "value": 20}],
			"decline": [{"type": "society_point", "value": -3}],
		}
	],
	"university": [
		null,
		{ "id": "学務委員に選出されました。", "effect": [{ "type": "university_hour_year", "value": 100 }, {"type": "university_point", "value": 1}] },
		{ "id": "学科長に選出されました", "effect": [{ "type": "university_hour_year", "value": 100 }, {"type": "university_point", "value": 4}],
			"require": "is_professor"
		},
		{ "id": "学部長に選出されました。", "effect": [{ "type": "university_hour_year", "value": 200 }, {"type": "university_point", "value": 20}],
			"require": "is_professor"
		},
		{ "id": "退職教授の後任の人事担当の依頼がありました。",
			"optional": true,
			"effect": [{ "type": "university_hour_tmp", "value": 100 }, {"type": "university_point", "value": 5}],
			"decline": [{"type": "university_point", "value": -3}],
			"require": "is_professor"
		},
		{ "id": "国際提携校締結に尽力しました。",
			"effect": [{ "type": "university_hour_tmp", "value": 100 }, {"type": "university_point", "value": 10}],
			"require": "is_professor"
		},
		{ "id": "学内の不祥事に対応しました。", "effect": [{ "type": "university_hour_tmp", "value": 50 }, {"type": "university_point", "value": 4}] }
	],
	"wild": [
		null,
		null,
		{ "id": "科研費Cの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 50}, { "type": "apply_kaken", "wait": 8, "year": 2, "money": 1 } ], "require": "not_applied"},
		{ "id": "科研費Aの申請をしました。", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 3, "money": 10 } ], "require": "not_applied"},
		{ "id": "海外研修を考えています。", "optional": true, "effect": [{ "type": "private_hour_year", "value": 200 }, { "type": "abroad" }],
			"require": "not_abroad"
		},
	]
}

func select():
	active = true
	return pickup_event()

func deselect():
	$Cell.rotation.z = 0
	active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cell.translation.x = radius
	$Cell/Default.hide()
	$Cell/Question.hide()
	$Cell/Asterisk.hide()
	$Cell/University.hide()
	$Cell/Dollar.hide()
	$Cell/Society.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if initialized == false:
		set_kind(kind)
		initialized = true
	if active:
		$Cell.rotate_z(0.8 * delta)

func upgrade():
	pass

func pickup_event():
	var nev = events[kind].size()
	if nev == 0:
		return null
	var chance = int((rand_range(0, nev + 0.1) * rand_range(0, nev + 0.1)) / nev)
	if nev <= chance:
		chance = nev - 1
	return events[kind][rand_range(0, nev)]

func set_kind(type):
	match type:
		"chance":
			$Cell/Question.show()
		"money":
			$Cell/Dollar.show()
		"private":
			$Cell/Default.set_surface_material(0, private_material)
			$Cell/Default.show()
		"society":
			$Cell/Society.show()
		"university":
			$Cell/University.show()
		"wild":
			$Cell/Asterisk.show()
		_: print("error")
	kind = type
