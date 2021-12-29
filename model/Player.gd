extends Node
class_name Player

var rank = 0
# var point = 0
var year = 0
# var age = 25
var number_of_papers = [0, 1, 0, 0, 0]
var skill_level = 1
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
var submission = [{ "state": "submit", "wait": 2, "level": 1 } ]

func _init():
	pass

func turn():
	pass

func submit(level):
	submission.push_back({ "state": "submit", "wait": int(rand_range(1, 2)), "level": level })
	writing_hour = 0
	print(submission)

class SubmissionSorter:
	static func sort_waiting_time(a, b):
		if a["wait"] < b["wait"]:
			return true
		return false

func update_submission():
	if submission.size() == 0:
		return null
	var tmp = []
	var expired = false
	for i in range(0, submission.size()):
		if 0 < submission[i]["wait"]:
			tmp.push_back(submission[i])
		else:
			expired = true
	submission = tmp
	if submission.size() == 0:
		if expired:
			return null
		return null
	submission.sort_custom(SubmissionSorter, "sort_waiting_time")
	submission[0]["wait"] -= 1
	if submission[0]["wait"] == 0:
		match submission[0]["state"]:
			"submit":
				# submission[0]["state"] = "wait_expire"
				# submission[0]["wait"] = 2
				if 0.6 < rand_range(0.0, 1.0):
					number_of_papers[submission[0]["level"]] += 1
					submission.pop_front()
					print(number_of_papers)
					return { "id": "論文が受理されました" }
				if 0.5 < rand_range(0.0, 1.0):
					return { "id": "論文の内容について1回目の照会です" }
				else:
					return { "id": "論文は不受理となりました" }
					submission.pop_front()
			_: return null
	return null

func turn_end():
	writing_hour += hour
	step = 0
	hour = 600
	event_hour = 0

func year_end():
	year += 1
	if 30 < year:
		return {"kind": 2, "message": "十分な実績を残すことができませんでした" }
	if 0 < kaken["year"]:
		kaken["year"] -= 1
		money += kaken["money"]
	else:
		kaken["money"] = 0
	contribution_point += 10 * number_of_postdocs
	contribution_point += number_of_students
	number_of_postdocs = 0
	number_of_students = 0
	var level_up = false
	if 2 < number_of_papers[0]:
		level_up = true
		skill_level += 1
	var promoted = false
	if -10 < skill_level and rank == 0:
		rank = 1
		level_in_university += 1
		level_in_society += 1
		promoted = true
	if rank == 0:
		money = 100 + university_rank * 50
	else:
		money = 200 + university_rank * 200
	if level_up and promoted:
		return { "kind": 1, "message": "教授に昇進し、研究レベルが上がりました" }
	elif level_up:
		return { "kind": 0, "message": "研究レベルが上がりました" }
	elif promoted:
		return { "kind": 1, "message": "教授に昇進しました" }
	else:
		return null

func update_research_hour():
	hour += number_of_students * 50
	hour += number_of_postdocs * 50
	hour -= level_in_university * 40
	hour -= level_in_society * 40
	if hour < 0:
		writing_hour += hour
		hour = 0
