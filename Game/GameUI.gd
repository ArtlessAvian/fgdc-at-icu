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
	$BurstMeter1.max_value = get_node(game_path).get_node("Fighter1").max_burst_meter
	$BurstMeter1.value = get_node(game_path).get_node("Fighter1").burst
	$BurstMeter2.max_value = get_node(game_path).get_node("Fighter2").max_burst_meter
	$BurstMeter2.value = get_node(game_path).get_node("Fighter2").burst

	# $Input.text = str(get_node(game_path).get_node("Fighter1/InputHistory")._stick_history) + "\n"
	# $Input.text += str(get_node(game_path).get_node("Fighter2/InputHistory")._stick_history)

	# yes they're meant to be swapped
	combo_stuff($ComboTEMP, $ComboTEMP3, get_node(game_path).get_node("Fighter2"))
	combo_stuff($ComboTEMP2, $ComboTEMP4, get_node(game_path).get_node("Fighter1"))

	dump_inputs($Input, $Input3, get_node(game_path).get_node("Fighter1/InputHistory"))
	dump_inputs($Input2, $Input4, get_node(game_path).get_node("Fighter2/InputHistory"))


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


const buttons = ["L", "H", "D"]


func dump_inputs(input, holds, input_history):
	input.text = ""
	holds.text = ""
	for i in range(len(input_history._stick_history)):
		input.text += str(input_history._stick_history[i])
		var butts = input_history._button_history[i]
		for j in range(len(buttons)):
			if (int(butts) >> j) & 1 == 1:
				input.text += buttons[j]

		holds.text += str(input_history._hold_duration[i])

		input.text += "\n"
		holds.text += "\n"
