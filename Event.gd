extends Spatial

var initialized = false
var active = false
var kind = null
var radius = 1.5
# var basic_material = load("art/Cell/BasicEvent.tres")
# var advanced_material = load("art/Cell/AdvancedEvent.tres")
# var chance_material = load("art/Cell/chanceColor.tres")
# var money_material = load("art/Cell/moneyColor.tres")
var private_material = load("art/Cell/privateColor.tres")
# var society_material = load("art/Cell/societyColor.tres")
# ar university_material = load("art/Cell/universityColor.tres")
# var wild_material = load("art/Cell/wildColor.tres")
var events = {
	"chance": [
		null,
		{ "id": "TV出演",
			"optional": true,
			"effect": [{ "type": "society_hour_tmp", "value": 50 }, {"type": "contribution_point", "value": 5}],
			"require": "is_skill_level3",
		},
		{ "id": "学会表彰", "effect": [{ "type": "connection_point", "value": 1}]},
		{ "id": "特許成立", "effect": [{ "type": "private_hour_tmp", "value": 20 }, {"type": "money", "value": 500}],
			"require": "is_skill_level2"
		},
		# { "id": "T大学に移る",
		# 	"optional": true,
		# 	 "effect": []
		# },
		{ "id": "国内学会招待講演",
			"optional": true,
			"effect": [{ "type": "hour", "value": -10 }, {"type": "society_point", "value": 5}, {"type": "connection_point", "value": 5}],
			"decline": [{"type": "society_point", "value": -2}],
			"require": "is_skill_level3"
		},
		{ "id": "国際会議招待講演",
			"optional": true,
			"effect": [{ "type": "hour", "value": -100 }, {"type": "society_point", "value": 10}, {"type": "connection_point", "value": 40}],
			"decline": [{"type": "society_point", "value": -2}],
			"require": "is_skill_level3"
		}
	],
	"money": [
		{ "id": "科研費B申請", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 7, "year": 2, "money": 2_000 } ], "require": "not_applied" },
		{ "id": "学内研究補助金獲得", "effect": [{ "type": "money", "value": 500 } ] },
		{ "id": "地元中小企業との共同研究", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 2_000 }] },
		{ "id": "科研費C申請", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 2, "money": 1_000 } ], "require": "not_applied"},
		{ "id": "科研費A申請", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 3, "money": 10_000 } ], "require": "not_applied"},
		{ "id": "大企業との共同研究", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 6_000 }] },
		{ "id": "科研費共同研究採択", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "kaken_money", "year":2, "money": 1_000 }], "require": "not_applied" },
		{ "id": "科研費大型プロジェクト採択", "effect": [{ "type": "private_hour_year", "value": 100 }, { "type": "kaen_money", "year": 2, "money": 5_000 } ],
			"require": "not_applied"
		},
		{ "id": "経済産業省助成金獲得", "effect": [{ "type": "private_hour_year", "value": 50 }, { "type": "money", "value": 10_000 }],
			"require": "is_skill_level3"
		}
	],
	"private": [
		null,
		{ "id": "twitter炎上", "effect": [{ "type": "private_hour_tmp", "value": 20 }] },
		{ "id": "過労で入院", "effect": [{ "type": "private_hour_year", "value": 300 }, { "type": "university_point", "value": -2}] },
		{ "id": "子供が生まれる", "effect": [{ "type": "private_hour_year", "value": 100 }], "require": "is_married" },
		{ "id": "交通事故で入院", "effect": [{ "type": "private_hour_tmp", "value": 300 },  { "type": "university_point", "value": -2}] }
	],
	"society": [
		null,
		{ "id": "論文査読",
			"optional": true,
			"effect": [{ "type": "society_hour_tmp", "value": 50 }, {"type": "society_point", "value": 5}],
			"decline": [{"type": "society_point", "value": -3}]
		},
		{ "id": "研究会開催", "effect": [{ "type": "society_hour_tmp", "value": 50 }, {"type": "society_point", "value": 5}]},
		{ "id": "国際大会開催",
			"optional": true,
			"effect": [{ "type": "society_hour_tmp", "value": 200 }, {"type": "society_point", "value": 20}],
			"decline": [{"type": "society_point", "value": -3}],
			"require": "is_professor"
		}
	],
	"university": [
		{ "id": "学生との打ち合わせ", "effect": [{ "type": "student_hour_tmp", "value": 10 }],
			"require": "has_student"
		},
		{ "id": "ポスドクとの打ち合わせ", "effect": [{ "type": "postdoc_hour_tmp", "value": 20 }],
			"require": "has_postdoc"
		},
		{ "id": "学内研究補助金獲得", "effect": [{ "type": "money", "value": 1000 } ] },
		{ "id": "学務委員選出", "effect": [{ "type": "university_hour_year", "value": 100 }, {"type": "university_point", "value": 1}] },
		{ "id": "学科長選出", "effect": [{ "type": "university_hour_year", "value": 100 }, {"type": "university_point", "value": 4}],
			"require": "is_professor"
		},
		{ "id": "学部長選出", "effect": [{ "type": "university_hour_year", "value": 200 }, {"type": "university_point", "value": 20}],
			"require": "is_professor"
		},
		{ "id": "国際提携校締結", "effect": [{ "type": "university_hour_tmp", "value": 100 }, {"type": "university_point", "value": 10}],
			"require": "is_professor"
		},
		{ "id": "学内不祥事対応", "effect": [{ "type": "university_hour_tmp", "value": 50 }, {"type": "university_point", "value": 4}] }
	],
	"wild": [
		{ "id": "科研費C申請", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 2, "money": 1_000 } ], "require": "not_applied"},
		{ "id": "科研費A申請", "effect": [{ "type": "private_hour_tmp", "value": 100}, { "type": "apply_kaken", "wait": 8, "year": 3, "money": 10_000 } ], "require": "not_applied"},
		{ "id": "海外研修", "effect": [{ "type": "private_hour_year", "value": 200 } ] },
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
	# $Cell/Default.set_surface_material(0, advanced_material)
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
