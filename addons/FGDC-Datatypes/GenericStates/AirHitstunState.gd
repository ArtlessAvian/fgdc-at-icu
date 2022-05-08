extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > f.state_dict.hitstun:
		f.combo_count = 0

		# choose when to flip out.
		if input.light or input.heavy:
			print("flip out")
			f.vel.x += input.stick_x * 6 << 16
			f.vel.y = 3 << 16
			return moveset.jump

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
		character.modulate.r = 1
		character.modulate.g = 1 - 1.0 / (f.state_time / 10.0 + 1)
		character.modulate.b = 1 - 1.0 / (f.state_time / 10.0 + 1)


func animation(f: Fighter) -> String:
	return "Hitstun"


# func do_landing(f: Fighter, moveset: Moveset) -> void:


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return moveset.knockdown as State
