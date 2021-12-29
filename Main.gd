extends Spatial

var player = load("model/Player.gd").new()
var step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Console/EventHappened.hide()
	$Console/StatusReport.hide()
	$GameSpace/ProfessorLife.hide()
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	update_state_panel()
	update_research_hour()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	$Console/EventHappened/EventDisplayTimer.stop()
	$Console/EventHappened.hide()
	var s = int((rand_range(0, 3.3) * rand_range(0, 3.3)) / 3  + 1)
	step += s
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	if 2 <= step:
		player.turn_end()
		var sl = player.submittable()
		if 0 < sl:
			$Console/Level1Button.disabled = false
		if 1 < sl:
			$Console/Level2Button.disabled = false
		if 2 < sl:
			$Console/Level3Button.disabled = false
	var new_year = false
	var paper_work = player.update_submission()
	if player.rank == 0:
		new_year = $GameSpace/AssistantLife.go_forward(s, paper_work)
	else:
		new_year = $GameSpace/ProfessorLife.go_forward(s, paper_work)
	if new_year:
		year_end()

func _on_event_happened(event):
	print(event)
	# return
	if event.get("optional", false):
		$Console/EventHappened.display(event["id"] + "かも")
	else:
		$Console/EventHappened.display(event["id"])
	if event.has("type") and event["type"] == "univ":
		player.event_hour += event["hour"]
		player.event_hour += event["hour"]
	update_research_hour()
	update_state_panel()

func year_end():
	var ret = player.year_end()
	if ret == null:
		$Console/StatusReport.display("研究者になって%s年が経ちました" %  player.year)
		return
	match ret["kind"]:
		0:
			$StatuReport.display(ret["message"])
		1:
			$Console/StatusReport.display(ret["message"])
			$GameSpace/AssistantLife.hide()
			$GameSpace/ProfessorLife.show()
		2:
			$Console/StatusReport.display(ret["message"])
			# FIXME 強制終了の処理

func update_research_hour():
	player.update_research_hour()
	$ResearchPanel/Panel/Resource/TimeTable/Team/Student.text = "%s(%s人)" % [player.number_of_students, player.number_of_students * 50]
	$ResearchPanel/Panel/Resource/TimeTable/Team/PostDoc.text = "%s(%s人)" % [player.number_of_postdocs, player.number_of_postdocs * 50]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/Time.text = "%s" % (player.hour - player.event_hour)
	$ResearchPanel/Panel/Resource/TimeTable/Personal/JobForUniv.text = "%s" % (player.level_in_university * -40)
	$ResearchPanel/Panel/Resource/TimeTable/Personal/JobForSoc.text = "%s" % (player.level_in_society * -40)
	$ResearchPanel/Panel/Resource/TimeTable/Personal/TotalHour.text = "%s" % (player.hour - player.event_hour)
	$ResearchPanel/Panel/Resource/TimeTable/Personal/WritingTime.text = "%s" % player.writing_hour

func update_state_panel():
	$StatusPanel/Panel/Status/Personal/ResearchLevel.text = '%dx%d' % [player.skill_level, player.number_of_papers[1]]
	$StatusPanel/Panel/Status/Personal/UniversityPoint.text = '%d' % player.university_point
	$StatusPanel/Panel/Status/Personal/ConnectionPoint.text = '%d' % player.connection_point
	$StatusPanel/Panel/Status/Personal/ContributionPoint.text = '%d' % player.contribution_point
	$StatusPanel/Panel/Status/Personal/Money.text = '%d' % player.money

func _on_Level1Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	$Console/StatusReport.display("論文を投稿しました")
	player.submit(1)
	update_research_hour()

func _on_Level2Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	$Console/StatusReport.display("論文を投稿しました")
	player.submit(2)
	update_research_hour()

func _on_Level3Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	$Console/StatusReport.display("論文を投稿しました")
	player.submit(3)
	update_research_hour()
