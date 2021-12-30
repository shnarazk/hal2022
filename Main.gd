extends Spatial

var player = load("model/Player.gd").new()
var step = 0
var weeks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ResearchPanel.hide()
	$Console/EventHappened.hide()
	$Console/StatusReport.hide()
	$GameSpace/ProfessorStage.hide()
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	update_state_panel()
	update_research_panel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	$Console/EventHappened/EventDisplayTimer.stop()
	$Console/EventHappened.hide()
	var s = int((rand_range(0, 3.3) * rand_range(0, 3.3)) / 3  + 1)
	step += s
	weeks += s
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	var paper_work = null
	if 2 <= weeks:
		paper_work = player.update_submission()
		var sl = player.submittable()
		if 0 < sl:
			$Console/Level1Button.disabled = false
		if 1 < sl:
			$Console/Level2Button.disabled = false
		if 2 < sl:
			$Console/Level3Button.disabled = false
	var new_year = false
	if player.rank == 0:
		new_year = $GameSpace/AssistantStage.go_forward(s, player, paper_work)
	else:
		new_year = $GameSpace/ProfessorStage.go_forward(s, player, paper_work)
	$ResearchPanel.hide()
	if 2 <= weeks:
		weeks = 0
		player.turn_end()
		$ResearchPanel.show()
	if new_year:
		year_end()
		$ResearchPanel.show()

func _on_event_happened(event):
	#print(event)
	if event.get("optional", false):
		var doit = 0.5 < rand_range(0, 1)
		var e = player.accept_proposal(event, !doit)
		$Console/EventHappened.display(("とりあえず" if doit else "断ったのは") + e["id"])
	else:
		var e = player.accept_proposal(event)
		$Console/EventHappened.display(e["id"])
	update_research_panel()
	update_state_panel()

func year_end():
	var ret = player.year_end()
	if ret == null:
		$Console/StatusReport.display("研究者になって%s年が経ちました" %  player.year)
		return
	match ret["kind"]:
		0:
			$Console/StatusReport.display(ret["message"])
		1:
			$Console/StatusReport.display(ret["message"])
			$GameSpace/AssistantStage.hide()
			$GameSpace/ProfessorStage.show()
		2:
			$Console/StatusReport.display(ret["message"])
			# Game Over
			$OpeningPanel.show()

func update_research_panel():
	# player.update_research_hour()
	var lab_hour = 50 * player.number_of_students + 100 * player.number_of_postdocs
	var my_hour = player.hour - player.university_hour["hour"] - player.society_hour["hour"] - player.private_hour["hour"] - player.student_hour["hour"] - player.postdoc_hour["hour"]
	$ResearchPanel/Panel/Resource/TimeTable/Team/Student.text = "%s(%s人)" % [player.number_of_students * 50, player.number_of_students]
	$ResearchPanel/Panel/Resource/TimeTable/Team/PostDoc.text = "%s(%s人)" % [player.number_of_postdocs * 100, player.number_of_postdocs]
	$ResearchPanel/Panel/Resource/TimeTable/Team/ResearchHour.text = "%d" % lab_hour
	$ResearchPanel/Panel/Resource/TimeTable/Personal/Time.text = "%s" % player.hour
	$ResearchPanel/Panel/Resource/TimeTable/Personal/UniversityHour.text = "%s" % -player.university_hour["hour"]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/SocietyHour.text = "%s" % -player.society_hour["hour"]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/PrivateHour.text = "%s" % -player.private_hour["hour"]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/Student.text = "%s" % -player.student_hour["hour"]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/PostDoc.text = "%s" % -player.postdoc_hour["hour"]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/ResearchHour.text = "%s" % my_hour
	$ResearchPanel/Panel/Resource/TimeTable/Personal/TotalHour.text = "%s" % max(0, my_hour + lab_hour)
	$ResearchPanel/Panel/Resource/TimeTable/Personal/WritingTime.text = "%s" % player.writing_hour

func update_state_panel():
	$StatusPanel/Panel/Status/Personal/ResearchLevel.text = '%dx%d' % [player.skill_level, player.number_of_papers[1]]
	$StatusPanel/Panel/Status/Personal/UniversityPoint.text = '%d' % player.university_point
	$StatusPanel/Panel/Status/Personal/ConnectionPoint.text = '%d' % player.connection_point
	$StatusPanel/Panel/Status/Personal/ContributionPoint.text = '%d' % player.contribution_point
	$StatusPanel/Panel/Status/Personal/Money.text = '%.2f M円' % player.money

func _on_Level1Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	$Console/StatusReport.display("論文を投稿しました")
	player.submit(1)
	update_research_panel()
	update_state_panel()

func _on_Level2Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	$Console/StatusReport.display("論文を投稿しました")
	player.submit(2)
	update_research_panel()
	update_state_panel()

func _on_Level3Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	$Console/StatusReport.display("論文を投稿しました")
	player.submit(3)
	update_research_panel()
	update_state_panel()

func _on_StartButton_pressed():
	$OpeningPanel.hide()
