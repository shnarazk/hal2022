extends Node
class_name skill

var levels = [
	{"level": 1, "requires": [0, 0, 0, 0, 0], "points": [0, 0, 0]},
	{"level": 2, "requires": [4, 0, 0, 0, 0], "points": [0, 0, 0]},
	{"level": 3, "requires": [5, 3, 0, 0, 0], "points": [0, 0, 0]},
	{"level": 4, "requires": [5, 4, 3, 0, 0], "points": [0, 0, 0]},
	{"level": 5, "requires": [5, 5, 5, 5, 0], "points": [0, 0, 0]},
]

var submitions = [
	{"level": 1, "hour": 750, "money": 500},
	{"level": 2, "hour": 1200, "money": 1000},
	{"level": 3, "hour": 1800, "money": 2000},
	{"level": 4, "hour": 2500, "money": 4000},
	{"level": 5, "hour": 2800, "money": 8000},
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func skill_level(_goal, achievement) -> int:
	var level = 0
	for i in range(2, 5):
		var passed = true
		for c in range(0, i):
			if achievement["number"][c] < levels["requires"][c]:
				passed = false
				return level
		level = i
	return level

func sumbittable(_goal, level, hour, money) -> bool:
	return submitions["level"] <= hour and submitions["level"]["money"] <= money
