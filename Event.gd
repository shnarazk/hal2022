extends Spatial

var active = false
var kind = ""
var radius = 1.5
var basic_material = load("art/BasicEvent.tres")
var advanced_material = load("art/AdvancedEvent.tres")
var chance_material = load("art/chanceColor.tres")
var money_material = load("art/moneyColor.tres")
var private_material = load("art/privateColor.tres")
var society_material = load("art/societyColor.tres")
var university_material = load("art/universityColor.tres")
var wild_material = load("art/wildColor.tres")
var events = {
	"chance": [
		{ "message": "TV出演",
			"optional": true,
			"effect": [{ "type": "hour", "value": -50 }, {"type": "contribution_point", "value": 5}],
			"require": "is_skill_level3",
		},
		{ "message": "学会表彰", "effect": [{ "type": "connection_point", "value": 1}]},
		{ "message": "特許成立", "effect": [{ "type": "hour", "value": -20 }, {"type": "money", "value": 500}],
			"require": "is_skill_level2"
		},
		{ "message": "T大学に移る",
			"optional": true,
			 "effect": []
		},
		{ "message": "国内学会招待講演",
			"optional": true,
			"effect": [{ "type": "hour", "value": -10 }, {"type": "society_point", "value": 5}, {"type": "connection_point", "value": 5}],
			"decline": [{"type": "society_point", "value": -2}],
			"require": "is_skill_level3"
		},
		{ "message": "国際会議招待講演",
			"optional": true,
			"effect": [{ "type": "hour", "value": -100 }, {"type": "society_point", "value": 10}, {"type": "connection_point", "value": 40}],
			"decline": [{"type": "society_point", "value": -2}],
			"require": "is_skill_level3"
		}
	],
	"money": [
		{ "message": "企業との共同研究", "effect": [{ "type": "hour", "value": -40 }, { "type": "money", "value": 2500 }] },
		{ "message": "科研費共同研究採択", "effect": [{ "type": "hour", "value": -100 }, { "type": "money", "value": 3000 }] },
		{ "message": "通産省助成金獲得", "effect": [{ "type": "hour", "value": -50 }, { "type": "money", "value": 1000 }],
			"require": "is_skill_level3"
		}
	],
	"private": [
		{ "message": "twitter炎上", "effect": [{ "type": "hour", "value": -20 }] },
		{ "message": "過労で入院", "effect": [{ "type": "hour", "value": -300 }, { "type": "university_point", "value": -2}] },
		{ "message": "子供が生まれる", "effect": [{ "type": "hour", "value": -200 }], "require": "is_married" },
		{ "message": "交通事故で入院", "effect": [{ "type": "hour", "value": -100 },  { "type": "university_point", "value": -2}] }
	],
	"society": [
		{ "message": "論文査読",
			"optional": true,
			"effect": [{ "type": "hour", "value": -50 }, {"type": "society_point", "value": 5}],
			"decline": [{"type": "society_point", "value": -3}]
		},
		{ "message": "研究会開催", "effect": [{ "type": "hour", "value": -50 }, {"type": "society_point", "value": 5}]},
		{ "message": "国際大会開催",
			"optional": true,
			"effect": [{ "type": "hour", "value": -200 }, {"type": "society_point", "value": 20}],
			"decline": [{"type": "society_point", "value": -3}],
			"require": "is_professor"
		}
	],
	"university": [
		{ "message": "学生との打ち合わせ", "effect": [{ "type": "hour", "value": -10 }],
			"require": "has_student"
		},
		{ "message": "ポスドクとの打ち合わせ", "effect": [{ "type": "hour", "value": -20 }],
			"require": "has_postdoc"
		},
		{ "message": "学務委員選出", "effect": [{ "type": "hour", "value": -100 }, {"type": "university_point", "value": 1}] },
		{ "message": "学科長選出", "effect": [{ "type": "hour", "value": -100 }, {"type": "university_point", "value": 4}],
			"require": "is_professor"
		},
		{ "message": "学部長選出", "effect": [{ "type": "hour", "value": -200 }, {"type": "university_point", "value": 20}],
			"require": "is_professor"
		},
		{ "message": "国際提携校締結", "effect": [{ "type": "hour", "value": -100 }, {"type": "university_point", "value": 10}],
			"require": "is_professor"
		},
		{ "message": "学内不祥事対応", "effect": [{ "type": "hour", "value": -50 }, {"type": "university_point", "value": 4}] }
	],
	"wild": [
	]
}

func select():
	active = true

func deselect():
	$Cell.rotation.z = 0
	active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cell.translation.x = radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		$Cell.rotate_z(0.5 * delta)

func upgrade():
	$Cell/MeshInstance.set_surface_material(0, advanced_material)
	pass

func pickup_event():
	var ne = events[kind].size()
	return events[kind][rand_range(0, ne)]

func set_kind(type):
	match type:
		"chance": $Cell/MeshInstance.set_surface_material(0, chance_material)
		"money": $Cell/MeshInstance.set_surface_material(0, money_material)
		"private": $Cell/MeshInstance.set_surface_material(0, private_material)
		"society": $Cell/MeshInstance.set_surface_material(0, society_material)
		"university": $Cell/MeshInstance.set_surface_material(0, university_material)
		"wild": $Cell/MeshInstance.set_surface_material(0, wild_material)
		_: print("error")
	kind = type
