extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	# Burst activation
	if input.heavy and input.light and f.can_burst():
		f.invincible = false
		return moveset.burst

	if f.state_time > f.state_dict.hitstun:
		if len(f.combo_gaps) == 0 or f.combo_gaps[len(f.combo_gaps) - 1] != f.combo_count:
			f.combo_gaps.append(f.combo_count)

		# choose when to flip out.
		if input.light or input.heavy:
			f.combo_count = 0
			print("flip out")
			f.vel.x = input.stick_x * 10 << 16
			f.vel.y = 10 << 16

			# TODO: bandaid fix
			var character = f.find_node("Character")
			character.modulate = Color.white

			return moveset.flip

	return null


func run(f: Fighter, input: Dictionary) -> void:
	# visual stuff, i can use floats here lmao
	if f.state_time > f.state_dict.hitstun:
		var character = f.find_node("Character")
		var flash = 0.3 if f.state_time % 2 == 0 else 0.5
		character.modulate.r = flash
		character.modulate.g = flash
		character.modulate.b = 1
	else:
		var character = f.find_node("Character")
		character.modulate = Color.red.linear_interpolate(
			Color.white, f.state_time / 2.0 / f.state_dict.hitstun
		)


func animation(f: Fighter) -> String:
	return "Hitstun"


# func do_landing(f: Fighter, moveset: Moveset) -> void:


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return moveset.knockdown as State


func attack_level():
	return 8765309
