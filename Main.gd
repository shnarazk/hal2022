extends Spatial

var rank = 0
var point = 0
var year = 0
var age = 25
var number_of_papers = 0
var researcher_level = 0
var hour = 600
var writing_hour = 0
var number_of_students = 0
var number_of_postdocs = 0
var university = "T大"
var level_in_university = 1
var university_point = 10
var level_in_society = 1
var connection_point = 10
var contribution_point = 10
var step = 0
var event_hour = 0
var money = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
		writing_hour += hour
		step = 0
		hour = 600
		event_hour = 0
		if 950 < writing_hour:
			$Console/Level1Button.disabled = false
		if 1500 < writing_hour:
			$Console/Level2Button.disabled = false
		if 2200 < writing_hour:
			$Console/Level3Button.disabled = false
	if rank == 0:
		var new_year = $GameSpace/AssistantLife.go_forward(s)
		if new_year:
			year_end()
	else:
		$GameSpace/ProfessorLife.go_forward(s)

func _on_event_happened(priority, message):
	# print(message)
	# return
	$EventHappened.display(message["id"])
	# print("event handler: %s" % message)
	if message["type"] == "univ":
		event_hour += message["hour"]
		update_research_hour()
	point += priority
	if 10 < point and rank == 0:
		rank = 1
		point = 0
		$GameSpace/AssistantLife.hide()
		for e in $GameSpace/ProfessorLife.period:
			e.upgrade()
		$GameSpace/ProfessorLife.show()
		$StatusReport.display("教授になりました")

func year_end():
	year += 1
	$StatusReport.display("研究者になって%s年が経ちました" %  year)
	number_of_postdocs = 0
	number_of_students = 0

func update_research_hour():
	hour += number_of_students * 50
	$ResearchPanel/Panel/Resource/TimeTable/Team/Student.text = "%s(%s人)" % [number_of_students, number_of_students * 50]
	hour += number_of_postdocs * 50
	$ResearchPanel/Panel/Resource/TimeTable/Team/PostDoc.text = "%s(%s人)" % [number_of_postdocs, number_of_postdocs * 50]
	$ResearchPanel/Panel/Resource/TimeTable/Personal/Time.text = "%s" % (hour - event_hour)
	hour -= level_in_university * 40
	$ResearchPanel/Panel/Resource/TimeTable/Personal/JobForUniv.text = "%s" % (level_in_university * -40)
	hour -= level_in_society * 40
	$ResearchPanel/Panel/Resource/TimeTable/Personal/JobForSoc.text = "%s" % (level_in_society * -40)
	if hour < 0:
		writing_hour += hour
		hour = 0
	$ResearchPanel/Panel/Resource/TimeTable/Personal/TotalHour.text = "%s" % (hour - event_hour)
	$ResearchPanel/Panel/Resource/TimeTable/Personal/WritingTime.text = "%s" % writing_hour
	$RsearchPanel/Panel/Resource/Resource

func update_state_panel():
	$StatusPanel/Panel/Status/Personal/ResearchLevel.text = '%d' % researcher_level
	$StatusPanel/Panel/Status/Personal/UniversityPoint.text = '%d' % university_point
	$StatusPanel/Panel/Status/Personal/ConnectionPoint.text = '%d' % connection_point
	$StatusPanel/Panel/Status/Personal/ContributionPoint.text = '%d' % contribution_point
	$StatusPanel/Panel/Status/Personal/Money.text = '%d' % money

func _on_Level1Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	writing_hour = 0
	update_research_hour()
	$StatusReport.display("論文を投稿しました")

func _on_Level2Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	writing_hour = 0
	update_research_hour()
	$StatusReport.display("論文を投稿しました")

func _on_Level3Button_pressed():
	$Console/Level1Button.disabled = true
	$Console/Level2Button.disabled = true
	$Console/Level3Button.disabled = true
	writing_hour = 0
	update_research_hour()
	$StatusReport.display("論文を投稿しました")
