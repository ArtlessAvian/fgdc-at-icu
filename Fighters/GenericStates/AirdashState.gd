extends "../State.gd"

export(int) var speed


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.state in [moveset.jump, moveset.j_light, moveset.j_heavy]:
		if f.get_node("InputHistory").detect_motion([6, 5, 6], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([9, 5, 6], f.fixed_scale.x < 0, 8):
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	var jump = transition_into_jump(f, moveset, input)
	if jump != null:
		return jump

	# if input.stick_y < 0:
	# 	return moveset.crouch

	if f.state_time > 30:
		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.y = f.fighter_gravity

	# # if input.stick_x == 0:
	# # 	f.vel.x = 0
	# # if input.stick_x < 0:
	# # 	f.vel.x = -5 * 65536
	# if input.stick_x > 0:
	f.vel.x = 5 * 65536 * sign(f.fixed_scale.x)

	# var diff = f.fixed_position.x - f.get_node(f.opponent_path).fixed_position.x
	# if diff > 0 && f.fixed_scale.x > 0:
	# 	f.fixed_scale.x *= -1
	# if diff < 0 && f.fixed_scale.x < 0:
	# 	f.fixed_scale.x *= -1


func animation(f: Fighter) -> String:
	return "Walk" if f.vel.x != 0 else "Idle"
