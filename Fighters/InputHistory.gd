extends Node
class_name InputHistory

var _stick_history: Array = [5]
var _button_history: Array = [0]
var _hold_duration: Array = [0]
var _hold_total = 0

const BUTTON_LIST = ["light", "heavy", "dash"]


func _ready():
	pass


func new_input(input: Dictionary):
	var stick = input.stick_x + input.stick_y * 3 + 5
	var buttons = 0
	for i in range(len(BUTTON_LIST)):
		if input.get(BUTTON_LIST[i]):
			buttons |= 1 << i

	if _stick_history[0] == stick:
		if _button_history[0] == buttons:
			_hold_duration[0] += 1
			_hold_total += 1
			_clear_old_inputs()
			return

	_stick_history.push_front(stick)
	_button_history.push_front(buttons)
	_hold_duration.push_front(1)
	_hold_total += 1
	_clear_old_inputs()


func _clear_old_inputs():
	while _hold_total - _hold_duration[-1] > 60 and len(_stick_history) > 30:
		_hold_total -= _hold_duration[-1]

		_stick_history.pop_back()
		_button_history.pop_back()
		_hold_duration.pop_back()


# returns how fast the input was
func detect_motion(motion, reversed: bool, frames: int) -> bool:
	var index = 0
	var sum = 0
	for i in range(len(_stick_history)):
		var input = _stick_history[i]
		if reversed:
			if input % 3 == 1:
				input += 2
			elif input % 3 == 0:
				input -= 2

		if input == motion[len(motion) - 1 - index]:
			index += 1
			if index == len(motion):
				return true
		elif index > 0 and input != motion[len(motion) - 1 - (index - 1)]:
			index = 0
		sum += _hold_duration[i]
		if sum > frames:
			return false

	return false


func detect_charge_forward(reversed: bool, input_frames: int, hold_frames: int) -> bool:
	# if not holding forward, early exit
	if not (
		(_stick_history[0] % 3 == 0 and not reversed)
		or (_stick_history[0] % 3 == 1 and reversed)
	):
		return false

	# search for a back input within input_frames. make sure its held for hold_frames.
	var first_input_time = 0
	var charge_time = 0
	for i in range(len(_stick_history)):
		var is_backwards = (
			(_stick_history[i] % 3 == 1 and not reversed)
			or (_stick_history[i] % 3 == 0 and reversed)
		)

		if not is_backwards:
			first_input_time += charge_time
			charge_time = 0
			first_input_time += _hold_duration[i]
			if first_input_time > input_frames:
				return false
		else:
			charge_time += _hold_duration[i]
			if charge_time >= hold_frames:
				prints("succ", first_input_time, charge_time, SyncManager.current_tick)
				return true

	return false


# WARNING: COPY PASTED FROM ABOVE.
func detect_charge_up(input_frames: int, hold_frames: int) -> bool:
	# if not holding up, early exit. integer division intentional.
	if not ((_stick_history[0] - 1) / 3) == 2:
		return false

	# search for a back input within input_frames. make sure its held for hold_frames.
	var first_input_time = 0
	var charge_time = 0
	for i in range(len(_stick_history)):
		var is_down = ((_stick_history[i] - 1) / 3) == 0

		if not is_down:
			first_input_time += charge_time
			charge_time = 0
			first_input_time += _hold_duration[i]
			if first_input_time > input_frames:
				return false
		else:
			charge_time += _hold_duration[i]
			if charge_time >= hold_frames:
				prints("succ", first_input_time, charge_time, SyncManager.current_tick)
				return true

	return false


func detect_qcf(reversed: bool, frames: int) -> bool:
	# TODO: A crazyass could run KMP Search
	# I'm just going to do the dumb way that works.
	# Its not worth.
	if detect_motion([2, 3, 6], reversed, frames):
		return true
	if detect_motion([2, 6], reversed, frames):
		return true
	if detect_motion([1, 3, 6], reversed, frames):
		return true
	if detect_motion([1, 6], reversed, frames):
		return true
	return false


func detect_qcb(reversed: bool, frames: int) -> bool:
	return detect_qcf(not reversed, frames)


func detect_dp(reversed: bool, frames: int) -> bool:
	if detect_motion([6, 2, 3], reversed, frames):
		return true
	if detect_motion([6, 5, 2, 3], reversed, frames):
		return true
	if detect_motion([6, 3, 2, 3], reversed, frames):
		return true
	return false


func _save_state() -> Dictionary:
	return {
		stick_history = _stick_history.duplicate(),
		button_history = _button_history.duplicate(),
		hold_duration = _hold_duration.duplicate(),
		hold_total = _hold_total
	}
	# return {history = history.duplicate(), unconsumed = unconsumed}


func _load_state(save: Dictionary) -> void:
	_stick_history = save.stick_history.duplicate()
	_button_history = save.button_history.duplicate()
	_hold_duration = save.hold_duration.duplicate()
	_hold_total = save.hold_total
	# print(save)
