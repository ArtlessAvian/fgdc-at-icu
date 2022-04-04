extends "../State.gd"

export(int) var speed

# func detect_motion(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
# var history = f.get_node("InputHistory").history


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	# var jump = transition_into_jump(f, moveset, input)
	# if jump != null:
	# 	return jump

	# if input.stick_y < 0:
	# 	return moveset.crouch

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.y = f.fighter_gravity

	# if input.stick_x == 0:
	# 	f.vel.x = 0
	# if input.stick_x < 0:
	# 	f.vel.x = -5 * 65536
	# if input.stick_x > 0:
	# 	f.vel.x = 5 * 65536

	# var diff = f.fixed_position.x - f.get_node(f.opponent_path).fixed_position.x
	# if diff > 0 && f.fixed_scale.x > 0:
	# 	f.fixed_scale.x *= -1
	# if diff < 0 && f.fixed_scale.x < 0:
	# 	f.fixed_scale.x *= -1


func animation(f: Fighter) -> String:
	return "Walk" if f.vel.x != 0 else "Idle"
