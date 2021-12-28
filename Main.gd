extends Spatial

var rank = 0
var point = 0
var year = 0
var age = 25
var number_of_papers = 0
var researcher_level = 0
var hour = 600
var writing_hour = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$EventHappened.hide()
	$StatusReport.hide()
	$GameSpace/ProfessorLife.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	$EventHappened/EventDisplayTimer.stop()
	$EventHappened.hide()
	var step = int((rand_range(0, 3.3) * rand_range(0, 3.3)) / 3  + 1)
	if rank == 0:
		var new_year = $GameSpace/AssistantLife.go_forward(step)
		if new_year:
			year += 1
			$StatusReport.display("研究者になって%s年が経ちました" %  year)
			print(year)
	else:
		$GameSpace/ProfessorLife.go_forward(step)

func _on_event_happened(priority, message):
	# print(message)	# return
	$EventHappened.display(message["id"])
	# print("event handler: %s" % message)
	if message["type"] == "univ":
		hour -= message["hour"]
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
		
func update_research_hour():
	$ResearchPanel/Panel/Resource/TimeTable/Personal/TotalHour.text = "%s" % hour
	$RsearchPanel/Panel/Resource/Resource
