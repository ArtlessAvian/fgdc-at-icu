extends Control

var game_path: NodePath = "../.."


func _process(delta):
	var time_msecs = get_node(game_path).time_in_frames / 60
	var time_str = str(time_msecs)

	$TimerTEMPORARY.text = "Time Left:\n" + time_str
	$TextureProgress.value = get_node(game_path).get_node("Fighter1").health
	$TextureProgress2.value = get_node(game_path).get_node("Fighter2").health

	# yes they're meant to be swapped
	var p1_cc = get_node(game_path).get_node("Fighter2").combo_count
	if p1_cc == 0:
		$ComboTEMP.text = ""
	else:
		$ComboTEMP.text = str(p1_cc) + " combo!"
	var p2_cc = get_node(game_path).get_node("Fighter1").combo_count
	if p2_cc == 0:
		$ComboTEMP2.text = ""
	else:
		$ComboTEMP2.text = str(p2_cc) + " combo!"
