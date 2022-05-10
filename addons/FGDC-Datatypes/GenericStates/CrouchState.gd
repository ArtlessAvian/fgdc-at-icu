extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	var jump = transition_into_jump(f, moveset, input)
	if jump != null:
		return jump

	if input.stick_y >= 0:
		return moveset.walk

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x = 0

	var diff = f.fixed_position.x - f.get_node(f.opponent_path).fixed_position.x
	if diff > 0 && f.fixed_scale.x > 0:
		f.fixed_scale.x *= -1
	if diff < 0 && f.fixed_scale.x < 0:
		f.fixed_scale.x *= -1

	# TODO: Remove bandaid fix
	var character = f.find_node("Character")
	character.modulate = Color.white


func animation(f: Fighter) -> String:
	return "Crouch"


func can_block() -> bool:
	return true
