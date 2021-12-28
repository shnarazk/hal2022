extends Spatial

var rank = 0
var point = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$EventHappened.hide()
	$ProfessorLife.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$EventHappened/EventDisplayTimer.stop()
	$EventHappened.hide()
	var step = int((rand_range(0, 3.3) * rand_range(0, 3.3)) / 3  + 1)
	if rank == 0:
		$AssistantLife.go_forward(step)
	else:
		$ProfessorLife.go_forward(step)

func _on_event_happened(priority, message):
	$EventHappened.text = message
	$EventHappened.show()
	$EventHappened/EventDisplayTimer.start()
	point += priority
	if 10 < point and rank == 0:
		rank = 1
		point = 0		
		$AssistantLife.hide()
		$ProfessorLife.show()
		$EventHappened.text = "教授になりました"

func _on_EventDisplayTimer_timeout():
	$EventHappened.hide()
