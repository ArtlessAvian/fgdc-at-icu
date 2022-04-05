# # Network bs
# const NULL_INPUT = {
# 	stick_x = 0,
# 	stick_y = 0,
# 	light = false,
# 	heavy = false,
# }

# func _get_local_input() -> Dictionary:
# 	if is_dummy:
# 		return NULL_INPUT

# 	if is_mash:
# 		var input = {
# 			stick_x = int(randi() % 3 - 1),
# 			stick_y = int(randi() % 3 - 1),
# 			light = randf() < 0.1,
# 			heavy = randf() < 0.1,
# 		}
# 		return input

# 	var left = controlled_by + "_left"
# 	var right = controlled_by + "_right"
# 	var up = controlled_by + "_up"
# 	var down = controlled_by + "_down"
# 	var light = controlled_by + "_light"
# 	var heavy = controlled_by + "_heavy"

# 	var input = {
# 		stick_x = int(round(Input.get_axis(left, right))),
# 		stick_y = int(round(Input.get_axis(down, up))),
# 		light = Input.is_action_pressed(light),
# 		heavy = Input.is_action_just_pressed(heavy),
# 	}
# 	return input
