extends "res://addons/FGDC-Datatypes/State.gd"

export(int) var speed = 14 * 65536


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	var check_for_dash = false
	if f.state in [moveset.walk, moveset.crouch]:
		check_for_dash = true
	elif f.state_time > 0 and f.state in [moveset.light, moveset.c_light, moveset.heavy]:
		check_for_dash = true

	if check_for_dash:
		if f.get_node("InputHistory").button_pressed("dash", 10):
			return true
		if f.get_node("InputHistory").detect_motion([6, 5, 6], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([3, 5, 6], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([6, 5, 3], f.fixed_scale.x < 0, 8):
			return true
		if f.get_node("InputHistory").detect_motion([3, 5, 3], f.fixed_scale.x < 0, 8):
			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time < 12:
		return null

	# var attack = transition_into_attack(f, moveset, input)
	# if attack != null:
	# 	if (
	# 		(
	# 			(f.get_node(f.opponent_path).fixed_position.x - f.fixed_position.x)
	# 			* sign(f.fixed_scale.x)
	# 		)
	# 		< 0
	# 	):
	# 		f.fixed_scale.x = -f.fixed_scale.x
	# 	return attack

	if input.light:
		for state in moveset.attacks:
			print(state.resource_path)
			if "Sever" in state.resource_path:
				return state

	if input.heavy:
		for state in moveset.attacks:
			print(state.resource_path)
			if "Launch" in state.resource_path:
				return state

	if input.stick_y > 0:
		for state in moveset.movement:
			print(state.resource_path)
			if "RunJump" in state.resource_path:
				return state

	if input.stick_x != sign(f.fixed_scale.x) and not input.dash:
		return moveset.walk

	if input.stick_y < 0:
		return moveset.walk

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time < 15:
		f.vel.x = 0
	else:
		f.vel.x = speed * sign(f.fixed_scale.x)


func animation(f: Fighter) -> String:
	return "Run"


func ignore_collision() -> bool:
	return true
