extends Control

var game_path: NodePath = "../.."


func _process(delta):
	var time_msecs = get_node(game_path).time_in_frames / 60
	var time_str = str(time_msecs)

	$TimerTEMPORARY.text = "Time Left:\n" + time_str
	$TextureProgress.value = get_node(game_path).get_node("Fighter1").health
	$TextureProgress2.value = get_node(game_path).get_node("Fighter2").health
