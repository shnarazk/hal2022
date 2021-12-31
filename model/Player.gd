extends Node
class_name Player

signal game_over(finish, message)

var rank = 0
# var point = 0
var year = 0
# var age = 25
var number_of_papers = [0, 1, 0, 0, 0]
var skill_level = 1
var hour = 600
var writing_hour = 0
var university_hour = { "hour": 50, "year": 50, "default": 50 }
var society_hour = { "hour": 50, "year": 50, "default": 50 }
var private_hour = { "hour": 0, "year": 0, "default": 0 }
var student_hour = { "hour": 0, "year": 0, "default": 0 }
var postdoc_hour = { "hour": 0, "year": 0, "default": 0 }
var number_of_postdocs = 0
var number_of_ex_postdocs = 0
var number_of_students = 0
var number_of_ex_students = 0
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
var money = 0.5
var kaken = { "year": 0, "money": 1000 }
var kaken_submission = { "state": null, "wait": 8, "year": 0, "money": 0, "label": "" }
var submission = [] # [{ "state": "submit", "wait": 2, "level": 1, "confirm": 0 } ]
var hour_for_paper =  [400, 800, 1200, 1800, 2200, 2800]
var money_for_paper = [0.4, 0.4, 1.2, 3, 3, 5]
var number_of_paper_this_year = 0
var no_paper_in_row = 0
var abroad = false
var married = false

func _init():
	pass

func turn():
	pass

func accept_proposal(event, deny = false):
	var e = event.duplicate(true)
	var effects = e.get("decline", []) if deny else e.get("effect", [])
	for effect in effects:
		match effect.get("type", ""):
			"hour":
				print("hour : %s" % e)
			"university_hour_tmp":
				university_hour["hour"] += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"university_hour_year":
				university_hour["hour"] += effect.get("value", 0)
				university_hour["year"] += effect.get("value", 0)
				e["id"] += "（今年の仕事が%d時間増えました）" % effect.get("value", 0)
			"society_hour_tmp":
				society_hour["hour"] += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"society_hour_year":
				society_hour["hour"] += effect.get("value", 0)
				society_hour["year"] += effect.get("value", 0)
				e["id"] += "（今年の仕事が%d時間増えました）" % effect.get("value", 0)
			"private_hour_tmp":
				private_hour["hour"] += effect.get("value", 0)
				e["id"] += "（%d時間費やしました）" % effect.get("value", 0)
			"private_hour_year":
				private_hour["hour"] += effect.get("value", 0)
				private_hour["year"] += effect.get("value", 0)
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
				e["id"] += "（研究費が%.2fM円増えました）" % effect.get("value", 0)
			"connection_point":
				connection_point += effect.get("value", 0)
				e["id"] += "（人脈ポイントが%d増えました）" % effect.get("value", 0)
			"university_point":
				university_point += effect.get("value", 0)
				e["id"] += "（学内ポイントが%d増えました）" % effect.get("value", 0)
			"society_point":
				contribution_point += effect.get("value", 0)
				e["id"] += "（学会ポイントが%d増えました）" % effect.get("value", 0)
			"apply_kaken":
				kaken_submission["state"] = "apply"
				kaken_submission["wait"] = effect.get("wait")
				kaken_submission["year"] = effect.get("year")
				kaken_submission["money"] = effect.get("money")
			"kaken_money":
				kaken["state"] = "accepted"
				kaken["year"] = effect.get("year")
				kaken["money"] = effect.get("money")
				money += kaken["money"]
				e["id"] += "（資金が%.2fM円増えました）" % kaken["money"]
			"scientific misconduct":
				number_of_papers[skill_level] = 0
				number_of_papers[max(0, skill_level - 1)] = 0
				skill_level = max(1, skill_level - 2)
				money /= 10
				writing_hour = 0
				e["id"] += "（研究者ランクが大きく下がりました）"
			"abroad":
				abroad = true
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
		"not_applied":
			return kaken_submission["state"] == null
		"not_abroad":
			return !abroad
		"is_married":
			return married
		"":
			return true
		_:
			print("can't check condition of %s" % event)
			return false

## とりあえず同時投稿は禁止する
func submittable() -> int:
	if !submission.empty(): return 0
	for i in [3, 2, 1]:
		if hour_for_paper[i] <= writing_hour and money_for_paper[i] <= money:
			return i
	return 0

func submit(level):
	assert(submission.empty() and hour_for_paper[level] <= writing_hour and money_for_paper[level] <= money)
	submission.push_back({ "state": "submit", "wait": int(rand_range(1, 2)), "level": level, "confirm": 0 })
	writing_hour -= hour_for_paper[level]
	money -= money_for_paper[level]
	# print(submission)

class SubmissionSorter:
	static func sort_waiting_time(a, b):
		if a["wait"] < b["wait"]:
			return true
		return false

## メッセージが溢れないようにターンで更新されるキューは一つだけにする
func update_submission():
	var ret = update_kaken_submission()
	if ret != null:
		return ret
	return update_paper_submission()

func update_kaken_submission():
	if kaken.get("state", null) == null:
		return null
	kaken_submission["wait"] -= 1
	if kaken_submission["wait"] == 0:
		if 0.6 < rand_range(0.0, 1.0):
			kaken_submission["state"] = "accepted"
			kaken["year"] = kaken_submission["year"]
			kaken["money"] = kaken_submission["money"]
			money += kaken["money"]
			return { "id": "科研申請が採択されました。%.2f年間予算が増えました。" % kaken["year"]}
		else:
			kaken_submission["state"] = null
			return { "id": "科研の申請は不採択でした。"}
	pass

func update_paper_submission():
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
				if 0.4 + 0.15 * (submission[0]["level"] - 0.5 * skill_level) < rand_range(0.0, 1.0):
					number_of_papers[submission[0]["level"]] += 1
					number_of_paper_this_year += 1
					submission.pop_front()
					# print(number_of_papers)
					return { "id": "論文が受理されました。" }
				if 0.1 + 0.1 * submission[0]["level"] < rand_range(0.0, 1.0):
					if 2 < submission[0]["confirm"]:
						submission.pop_front()
						return { "id": "紹介の結果論文は不受理となりました。" }
					submission[0]["confirm"] += 1
					if 200 <= writing_hour and 1 < money and submission[0]["confirm"] < 2:
						submission[0]["wait"] = int(rand_range(1, 3))
						writing_hour -= 100
						money -= 1
						return { "id": "論文の内容について%d回目の照会がありました。資金と時間を取られました。" % submission[0]["confirm"]}
					else:
						var count = submission[0]["confirm"]
						submission.pop_front()
						return { "id": "投稿論文について%d回目の照会がありましたが対応できませんでした。" % count}
				else:
					submission.pop_front()
					return { "id": "論文は不受理となりました。" }
			# _: return null
	return null

func turn_end():
	var lab_hour = 50 * number_of_students + 100 * number_of_postdocs - student_hour["hour"] - postdoc_hour["hour"]
	var my_hour = hour - university_hour["hour"] - society_hour["hour"] - private_hour["hour"]
	writing_hour += max(0, my_hour + lab_hour)
	hour = 600
	university_hour["hour"] = university_hour["year"]
	society_hour["hour"] = society_hour["year"]
	private_hour["hour"] = private_hour["year"]
	student_hour["hour"] = student_hour["year"]
	postdoc_hour["hour"] = postdoc_hour["year"]

func check_game_condition():
	if 20 < year:
		# return {"kind": 2, "message": "十分な実績を残すことができませんでした" }
		emit_signal("game_over", false, "%d年研究しましたが十分な実績を残すことができませんでした" % year)
		return true
	if connection_point < 0:
		emit_signal("game_over", false, "%人脈ポイントが低くなり過ぎて研究者として成功できませんでした。")
		return true
	if university_point < 0:
		emit_signal("game_over", false, "学内ポイントが低くなり過ぎて研究者として成功できませんでした。")
		return true
	if money < 0:
		emit_signal("game_over", false, "予算執行の問題で大学に迷惑をかけてしまい研究者として成功できませんでした。")
		return true
	if 3 < no_paper_in_row:
		emit_signal("game_over", false, "%d年間論文を発表できませんでした。" % no_paper_in_row)
		return true
	return false

func year_end():
	# wrap up this year
	var total_papers = 0
	for n in number_of_papers:
		total_papers += n
	var np = number_of_paper_this_year
	if number_of_paper_this_year == 0:
		no_paper_in_row += 1
	else:
		no_paper_in_row = 0
	# 年度末でできるだけ使い切る。次年度の収入が見込めるなら赤字は待てる。
	money /= 2
	if 0 < number_of_paper_this_year:
		money += 0.3
	else:
		money += 0.5 + pow(university_rank, 1.5) * 0.1
	if 0 < kaken["year"]:
		kaken["year"] -= 1
		money += kaken["money"]
		if kaken["year"] == 0:
			kaken_submission["state"] = null
			kaken["money"] = 0
	contribution_point += 10 * number_of_postdocs
	contribution_point += number_of_students
	# then check it
	if check_game_condition():
		print("game over")
		return
	# start a new year
	year += 1
	university_hour["year"] = university_hour["default"]
	university_hour["hour"] = university_hour["default"]
	society_hour["year"] = society_hour["default"]
	society_hour["hour"] = society_hour["default"]
	private_hour["year"] = private_hour["default"]
	private_hour["hour"] = private_hour["default"]
	student_hour["year"] = student_hour["default"]
	student_hour["hour"] = student_hour["default"]
	postdoc_hour["year"] = postdoc_hour["default"]
	postdoc_hour["hour"] = postdoc_hour["default"]
	number_of_postdocs = 0
	number_of_students = 0
	abroad = false
	var level_up = false
	if 2 < number_of_papers[skill_level] and 1 < number_of_paper_this_year:
		level_up = true
		skill_level = min(skill_level + 1, 5)
	var promoted = false
	number_of_paper_this_year = 0
	if rank == 0 and 5 < total_papers:
		rank = 1
		level_in_university += 1
		level_in_society += 1
		promoted = true
	if level_up and promoted:
		return { "kind": 1, "message": "教授に昇進し、研究レベルが上がりました。今年書いた論文は%d本です。" % np }
	elif level_up:
		return { "kind": 0, "message": "研究レベルが上がりました。今年書いた論文は%d本です。" % np }
	elif promoted:
		return { "kind": 1, "message": "教授に昇進しました。今年書いた論文は%d本です。" % np }
	else:
		return { "kind": 0, "message": "1年が終わりました。今年書いた論文は%d本です。" % np }
