extends Node

var history: Array = []


func _ready():
	for i in range(30):
		history.append(5)


func new_input(input: Dictionary):
	history.pop_back()

	# keypad notation
	history.push_front(input.stick_x + input.stick_y * 3 + 5)

	# print(history)


# returns how fast the input was
func detect_motion(motion, reversed: bool) -> int:
	var index = 0
	for i in range(len(history)):
		var input = history[i]
		if reversed:
			if input % 3 == 1:
				input += 2
			elif input % 3 == 0:
				input -= 2

		if input == motion[index]:
			index += 1
			if index == len(motion):
				return i
		elif index > 0 and input != motion[index - 1]:
			index = 0

	return 1000000000


func _save_state() -> Dictionary:
	return {history = history.duplicate()}


func _load_state(save: Dictionary) -> void:
	history = save.history
