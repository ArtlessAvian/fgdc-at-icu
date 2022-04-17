extends "../State.gd"

# TODO: Considering splitting jump and dj into separate states.
# Or not. Dirtier but cleaner in a different way.

export(int) var impulse = 12 * 65536
export(int) var double_jump_impulse = 6 * 65536
export(int) var horizontal_speed = 5 * 65536


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	# if f.air_actions > 0:
	# 	if f.get_node("InputHistory").detect_motion([6, 5, 6], f.fixed_scale.x < 0, 8):
	# 		f.get_node("InputHistory").consume_motion()
	# 		f.air_actions -= 1
	# 		return moveset.airdash

	var double_jump = transition_into_double_jump(f, moveset, input)
	if double_jump != null:
		return double_jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	pass


func animation(f: Fighter) -> String:
	return "Jump"


func can_block() -> bool:
	return true
