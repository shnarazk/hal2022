extends Node
class_name Player

var rank = 0
# var point = 0
var year = 0
# var age = 25
var number_of_papers = 0
var skill_level = 0
var hour = 600
var writing_hour = 0
var number_of_students = 0
var number_of_postdocs = 0
var university = "T大"
var university_rank = 1
var level_in_university = 1
var university_point = 10
var level_in_society = 1
var connection_point = 10
var contribution_point = 10
var step = 0
var event_hour = 0
var money = 500
var kaken = { "year": 0, "money": 1000 }

func _init():
	pass

func turn_end():
	writing_hour += hour
	step = 0
	hour = 600
	event_hour = 0

func year_end():
	year += 1
	if 30 < year:
		return {"kind": 1, "message": "十分な実績を残すことができませんでした"}
	if 0 < kaken["year"]:
		kaken["year"] -= 1
		money += kaken["money"]
	else:
		kaken["money"] = 0
	contribution_point += 10 * number_of_postdocs
	contribution_point += number_of_students
	number_of_postdocs = 0
	number_of_students = 0
	var promoted = false
	if 10 < skill_level and rank == 0:
		rank = 1
		level_in_university += 1
		level_in_society += 1
		promoted = true
	if rank == 0:
		money = 100 + university_rank * 50
	else:
		money = 200 + university_rank * 200
	if promoted:
		return { "kind": 2, "message": "教授に昇進しました" }
	else:
		return { "kind": 0 }

func update_research_hour():
	hour += number_of_students * 50
	hour += number_of_postdocs * 50
	hour -= level_in_university * 40
	hour -= level_in_society * 40
	if hour < 0:
		writing_hour += hour
		hour = 0
