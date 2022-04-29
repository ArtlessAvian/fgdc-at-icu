extends Control

var game_path: NodePath = "../.."


func _process(delta):
	var time_secs = get_node(game_path).time_in_frames / 60
	$TimerTEMPORARY.text = "Time Left:\n" + str(time_secs)
	$TextureProgress.value = get_node(game_path).get_node("Fighter1").health
	$TextureProgress2.value = get_node(game_path).get_node("Fighter2").health
