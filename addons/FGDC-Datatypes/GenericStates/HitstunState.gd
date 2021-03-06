extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	# Burst activation
	if input.heavy and input.light and f.can_burst():
		f.combo_count = 0
		return moveset.burst

	if f.state_time > f.state_dict.hitstun:
		f.combo_count = 0
		if f.grounded:
			return moveset.walk
		else:
			print("does this ever happen?")
	return null


func enter(f: Fighter) -> void:
	var stick = f.get_node("InputHistory")._stick_history[0]
	if stick == 1 or stick == 2 or stick == 3:
		f.state_dict["Crouching"] = true
	else:
		f.state_dict["Crouching"] = false


func run(f: Fighter, input: Dictionary) -> void:
	# visual stuff, i can use floats here lmao
	var character = f.find_node("Character")
	character.modulate = Color.red.linear_interpolate(
		Color.white, f.state_time / 2.0 / f.state_dict.hitstun
	)


func animation(f: Fighter) -> String:
	if f.state_dict["Crouching"]:
		if f.get_node("AnimationPlayer").has_animation("CrouchingHitstun"):
			return "CrouchingHitstun"
		return "Crouch"
	else:
		return "Hitstun"


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null


func attack_level():
	return 8765309
