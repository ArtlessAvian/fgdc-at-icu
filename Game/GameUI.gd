extends Control

var game_path: NodePath = "../.."


func _process(delta):
	var time_secs = get_node(game_path).time_in_frames / 60
	$TimerTEMPORARY.text = "Time Left: " + str(time_secs)
