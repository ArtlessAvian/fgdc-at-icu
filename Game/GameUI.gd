extends Control

var game_path: NodePath = "../.."


func _process(delta):
	var time_msecs = get_node(game_path).time_in_frames / 60
	var time_str = str(time_msecs)

	$TimerTEMPORARY.text = "Time Left:\n" + time_str
	$TextureProgress.max_value = get_node(game_path).get_node("Fighter1").max_health
	$TextureProgress.value = get_node(game_path).get_node("Fighter1").health
	$TextureProgress2.max_value = get_node(game_path).get_node("Fighter2").max_health
	$TextureProgress2.value = get_node(game_path).get_node("Fighter2").health

	$Input.text = str(get_node(game_path).get_node("Fighter1/InputHistory")._stick_history) + "\n"
	$Input.text += str(get_node(game_path).get_node("Fighter2/InputHistory")._stick_history)

	# yes they're meant to be swapped
	combo_stuff($ComboTEMP, $ComboTEMP3, get_node(game_path).get_node("Fighter2"))
	combo_stuff($ComboTEMP2, $ComboTEMP4, get_node(game_path).get_node("Fighter1"))


func combo_stuff(count, gaps, opponent):
	if opponent.combo_count == 0:
		count.text = ""
	else:
		count.text = str(opponent.combo_count) + " combo!"

	if len(opponent.combo_gaps) == 0:
		count.modulate = Color.white
		gaps.text = ""
	else:
		count.modulate = Color.cyan
		gaps.text = " "
		for val in opponent.combo_gaps:
			if val == opponent.combo_count:
				break
			gaps.text += str(val) + " "
