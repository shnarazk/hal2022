extends Spatial

var player = load("model/Player.gd").new()
var step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$EventHappened.hide()
	$StatusReport.hide()
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
	$EventHappened/EventDisplayTimer.stop()
	$EventHappened.hide()
	var s = int((rand_range(0, 3.3) * rand_range(0, 3.3)) / 3  + 1)
	step += s
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	if 2 <= step:
		player.turn_end()
		if 950 < player.writing_hour:
			$Console/Level1Button.disabled = false
		if 1500 < player.writing_hour:
			$Console/Level2Button.disabled = false
		if 2200 < player.writing_hour:
			$Console/Level3Button.disabled = false
	var new_year = false
	if player.rank == 0:
		new_year = $GameSpace/AssistantLife.go_forward(s)
	else:
		new_year = $GameSpace/ProfessorLife.go_forward(s)
	if new_year:
		year_end()

func _on_event_happened(event):
	print(event)
	# return
	if event.get("optional", false):
		$EventHappened.display(event["id"] + "かも")
	else:
		$EventHappened.display(event["id"])
	if event.has("type") and event["type"] == "univ":
		player.event_hour += event["hour"]
		player.event_hour += event["hour"]
		update_research_hour()

func year_end():
	var ret = player.year_end()
	match ret["kind"]:
		0:
			$StatusReport.display("研究者になって%s年が経ちました" %  player.year)
		1:
			$StatuReport.display(ret["message"])
			# FIXME 強制終了の処理
			return
		2:
			$StatusReport.display(ret["message"])
			$GameSpace/AssistantLife.hide()
			$GameSpace/ProfessorLife.show()

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
	$StatusPanel/Panel/Status/Personal/ResearchLevel.text = '%dx%d' % [player.skill_level, 0]
	$StatusPanel/Panel/Status/Personal/UniversityPoint.text = '%d' % player.university_point
	$StatusPanel/Panel/Status/Personal/ConnectionPoint.text = '%d' % player.connection_point
	$StatusPanel/Panel/Status/Personal/ContributionPoint.text = '%d' % player.contribution_point
	$StatusPanel/Panel/Status/Personal/Money.text = '%d' % player.money

func _on_Level1Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	player.writing_hour = 0
	update_research_hour()
	$StatusReport.display("論文を投稿しました")

func _on_Level2Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	player.writing_hour = 0
	update_research_hour()
	$StatusReport.display("論文を投稿しました")

func _on_Level3Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	player.writing_hour = 0
	update_research_hour()
	$StatusReport.display("論文を投稿しました")
