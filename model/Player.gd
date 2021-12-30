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
var university_hour_default = 50
var university_hour_year_init = university_hour_default
var university_hour = university_hour_year_init
var society_hour_default = 50
var society_hour_year_init = society_hour_default
var society_hour = society_hour_year_init
var private_hour_default = 0
var private_hour_year_init = private_hour_default
var private_hour = private_hour_year_init
var number_of_students = 0
var student_hour = { "hour": 0, "year": 0, "default": 0 }
var number_of_postdocs = 0
var postdoc_hour = { "hour": 0, "year": 0, "default": 0 }
# var postdoc_hour_default = 0
# var postdoc_hour_year_init = postdoc_hour_default
# var postdoc_hour = postdoc_hour_year_init
var university = "T大"
var university_rank = 1
var level_in_university = 1
var university_point = 10
var level_in_society = 1
var connection_point = 10
var contribution_point = 10
var money = 500
var kaken = { "year": 0, "money": 1000 }
var submission = [{ "state": "submit", "wait": 2, "level": 1, "confirm": 0 } ]
var hour_for_paper =  [400, 900, 2000, 3400, 2800, 3200]
var money_for_paper = [200, 500, 2000, 6000, 8000, 12000]

func _init():
	pass

func turn():
	pass

func accept_proposal(event):
	var e = event.duplicate(true)
	for effect in e.get("effect", []):
		match effect.get("type", ""):
			"hour":
				print("hour : %s" % e)
			"university_hour_tmp":
				university_hour += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"university_hour_year":
				university_hour += effect.get("value", 0)
				university_hour_year_init += effect.get("value", 0)
				e["id"] += "（今年の仕事が%d時間増えました）" % effect.get("value", 0)
			"society_hour_tmp":
				society_hour += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"society_hour_year":
				society_hour += effect.get("value", 0)
				society_hour_year_init += effect.get("value", 0)
				e["id"] += "（今年の仕事が%d時間増えました）" % effect.get("value", 0)
			"private_hour_tmp":
				private_hour += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"private_hour_year":
				private_hour += effect.get("value", 0)
				private_hour_year_init += effect.get("value", 0)
				e["id"] += "（今年の仕事が%d時間増えました）" % effect.get("value", 0)
			"student_hour_tmp":
				student_hour["hour"] += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"student_hour_year":
				student_hour["hour"] += effect.get("value", 0)
				student_hour["year"] += effect.get("value", 0)
				e["id"] += "（今年の打ち合わせが%d時間増えました）" % effect.get("value", 0)
			"postdoc_hour_tmp":
				postdoc_hour["hour"] += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"postdoc_hour_year":
				postdoc_hour["hour"] += effect.get("value", 0)
				postdoc_hour["year"] += effect.get("value", 0)
				e["id"] += "（今年の打ち合わせが%d時間増えました）" % effect.get("value", 0)
			"number_of_student":
				number_of_students += effect.get("value", 0)
				e["id"] += "（卒論生が%d人増えました）" % effect.get("value", 0)
			"number_of_postdoc":
				number_of_postdocs += effect.get("value", 0)
				e["id"] += "（ポスドクが%d人増えました）" % effect.get("value", 0)
			"money":
				money += effect.get("value", 0)
				e["id"] += "（研究費が%dK円増えました）" % effect.get("value", 0)
			"connection_point":
				connection_point += effect.get("value", 0)
				e["id"] += "（人脈ポイントが%d増えました）" % effect.get("value", 0)
			"university_point":
				university_point += effect.get("value", 0)
				e["id"] += "（学内ポイントが%d増えました）" % effect.get("value", 0)
			"society_point":
				contribution_point += effect.get("value", 0)
				e["id"] += "（学会ポイントが%d増えました）" % effect.get("value", 0)
			_: print("can't handle %s" % effect)
	return e

func reject_proposal(_event):
	pass

func check_event_condition(event) -> bool:
	match event.get("require", ""):
		"is_professor":
			return rank == 1
		"is_skill_level3":
			return 3 <= skill_level
		"is_skill_level2":
			return 2 <= skill_level
		"has_postdoc":
			return 0 < number_of_postdocs
		"has_student":
			return 0 < number_of_students
		"":
			return true
		_:
			print(event)
			return false

## とりあえず同時投稿は禁止する
func submittable() -> int:
	if !submission.empty(): return 0
	for i in [3, 2, 1]:
		if hour_for_paper[i] <= writing_hour and money_for_paper[i] <= money:
			return i
	return 0

func submit(level):
	if submission.empty() and hour_for_paper[level] <= writing_hour:
		submission.push_back({ "state": "submit", "wait": int(rand_range(1, 2)), "level": level, "confirm": 0 })
		writing_hour -= hour_for_paper[level]
		money -= money_for_paper[level]
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
			# 状態によるアクション選択はとりあえず中止
			_:
				# submission[0]["state"] = "wait_expire"
				# submission[0]["wait"] = 2
				if 0.35 + 0.15 * (submission[0]["level"] - 0.5 * skill_level) < rand_range(0.0, 1.0):
					number_of_papers[submission[0]["level"]] += 1
					submission.pop_front()
					print(number_of_papers)
					return { "id": "論文が受理されました。" }
				if 0.1 * submission[0]["level"] < rand_range(0.0, 1.0):
					if 2 < submission[0]["confirm"]:
						submission.pop_front()
						return { "id": "論文は不受理となりました。" }
					if 200 <= writing_hour and submission[0]["confirm"] < 2:
						submission[0]["confirm"] += 1
						submission[0]["wait"] = int(rand_range(1, 3))
						writing_hour -= 100
						return { "id": "論文の内容について%d回目の照会がありました。100時間取られました。" % submission[0]["confirm"]}
					else:
						var count = submission[0]["confirm"]
						submission.pop_front()
						return { "id": "投稿論文について%d回目の照会がありましたが対応できませんでした。" % count}
				else:
					submission.pop_front()
					return { "id": "論文は不受理となりました。" }
			_: return null
	return null

func turn_end():
	var lab_hour = 50 * number_of_students + 100 * number_of_postdocs - student_hour["hour"] - postdoc_hour["hour"]
	var my_hour = hour - university_hour - society_hour - private_hour
	writing_hour += my_hour + lab_hour
	hour = 600
	university_hour = university_hour_year_init
	society_hour = society_hour_year_init
	private_hour = private_hour_year_init
	student_hour["hour"] = student_hour["year"]
	postdoc_hour["hour"] = postdoc_hour["year"]

func year_end():
	year += 1
	if 30 < year:
		return {"kind": 2, "message": "十分な実績を残すことができませんでした" }

	university_hour_year_init = university_hour_default
	society_hour_year_init = society_hour_default
	private_hour_year_init = private_hour_default
	university_hour = university_hour_year_init
	society_hour = society_hour_year_init
	private_hour = private_hour_year_init

	student_hour["year"] = student_hour["default"]
	student_hour["hour"] = student_hour["default"]
	postdoc_hour["year"] = postdoc_hour["default"]
	postdoc_hour["hour"] = postdoc_hour["default"]

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
		money += 100 + pow(university_rank, 2) * 50
	else:
		money += 200 + pow(university_rank + skill_level, 1.8) * 200
	if 0 < kaken["year"]:
		kaken["year"] -= 1
		money += kaken["money"]
	money += 1000 * skill_level
	if level_up and promoted:
		return { "kind": 1, "message": "教授に昇進し、研究レベルが上がりました" }
	elif level_up:
		return { "kind": 0, "message": "研究レベルが上がりました" }
	elif promoted:
		return { "kind": 1, "message": "教授に昇進しました" }
	else:
		return null

func update_research_hour():
	var total = hour
	total += number_of_students * 50
	total += number_of_postdocs * 50
	total -= level_in_university * 40
	total -= level_in_society * 40
	if total < 0:
		writing_hour += total
		total = 0
