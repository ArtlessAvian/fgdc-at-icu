extends State

export(int) var impulse = 15


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false

	if f.state in [moveset.walk, moveset.crouch]:
		var success = false
		if f.get_node("InputHistory").detect_motion([2, 5, 8], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 5, 9], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 5, 7], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 6, 9], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 4, 7], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 5, 4, 7], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 4, 5, 7], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 5, 6, 9], f.fixed_scale.x < 0, 8):
			success = true
		elif f.get_node("InputHistory").detect_motion([2, 6, 5, 9], f.fixed_scale.x < 0, 8):
			success = true

		if success:
			f.vel.y = impulse * 65536
			f.grounded = false
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	var double_jump = transition_into_double_jump(f, moveset, input)
	if double_jump != null:
		return double_jump

	return null


func enter(f: Fighter) -> void:
	f.air_actions = f.moveset.air_actions


func run(f: Fighter, input: Dictionary) -> void:
	pass


func animation(f: Fighter) -> String:
	return "Jump"
