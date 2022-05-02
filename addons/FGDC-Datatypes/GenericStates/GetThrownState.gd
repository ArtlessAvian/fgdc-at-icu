extends "../State.gd"


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.light and input.heavy:
		if f.state_dict["throwdata"].techable:
			if f.state_time < f.state_dict["throwdata"].tech_window:
				# WARNING: TODO: HACK: Port priority is a factor!
				var opponent = f.get_node(f.opponent_path)
				opponent.change_to_state(opponent.moveset.throw_tech)
				# opponent.state_dict["throw_teched"] = true
				return moveset.throw_tech as State  # won't stop malding at me unless i do this

	if f.state_time >= f.state_dict["throwdata"].release_time:
		f.vel.x = (f.state_dict["throwdata"].release_vel_x << 16) * -int(sign(f.fixed_scale.x))
		f.vel.y = f.state_dict["throwdata"].release_vel_y << 16

		f.grounded = false
		f.invincible = false
		return moveset.knockdown

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.invincible = true


func animation(f: Fighter) -> String:
	return "Hitstun"


func attack_level() -> int:
	return 10
