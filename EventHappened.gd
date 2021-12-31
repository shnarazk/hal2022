extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func display(message, no_timer = false):
	text = message
	show()
	if !no_timer:
		$EventDisplayTimer.start()

func _on_EventDisplayTimer_timeout():
	hide()
