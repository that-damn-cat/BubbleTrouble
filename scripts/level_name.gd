extends Label

var last_label: String = ""

func _process(_delta):
	if globals.level_title == last_label:
		return

	text = globals.level_title + "   "
	last_label = globals.level_title