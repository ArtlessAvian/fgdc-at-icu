extends Node

var stick_history: Array = [5]
var button_history: Array = [0]
var hold_duration: Array = [0]
var hold_total = 0

const BUTTON_LIST = ["light", "heavy"]


func _ready():
	pass


func new_input(input: Dictionary):
	var stick = input.stick_x + input.stick_y * 3 + 5
	var buttons = 0
	for i in range(len(BUTTON_LIST)):
		if input.get(BUTTON_LIST[i]):
			buttons |= 1 << i

	if stick_history[0] == stick:
		if button_history[0] == buttons:
			hold_duration[0] += 1
			hold_total += 1
			clear_old_inputs()
			return

	stick_history.push_front(stick)
	button_history.push_front(buttons)
	hold_duration.push_front(1)
	hold_total += 1
	clear_old_inputs()


func clear_old_inputs():
	if hold_total - hold_duration[-1] > 60:
		hold_total -= hold_duration[-1]

		stick_history.pop_back()
		button_history.pop_back()
		hold_duration.pop_back()


# returns how fast the input was
func detect_motion(motion, reversed: bool) -> int:
	var index = 0
	var sum = 0
	for i in range(len(stick_history)):
		var input = stick_history[i]
		if reversed:
			if input % 3 == 1:
				input += 2
			elif input % 3 == 0:
				input -= 2

		if input == motion[len(motion) - 1 - index]:
			index += 1
			if index == len(motion):
				return sum
		elif index > 0 and input != motion[len(motion) - 1 - (index - 1)]:
			index = 0
		sum += hold_duration[i]

	return 1000000000


func consume_motion():
	pass


func _save_state() -> Dictionary:
	return {
		stick_history = stick_history.duplicate(),
		button_history = button_history.duplicate(),
		hold_duration = hold_duration.duplicate(),
		hold_total = hold_total
	}
	# return {history = history.duplicate(), unconsumed = unconsumed}


func _load_state(save: Dictionary) -> void:
	stick_history = save.stick_history
	button_history = save.button_history
	hold_duration = save.hold_duration
	hold_total = save.hold_total
