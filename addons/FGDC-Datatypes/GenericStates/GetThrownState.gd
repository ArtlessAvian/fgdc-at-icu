extends "../State.gd"


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if input.light and input.heavy and f.health > 0:
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
		f.health -= f.state_dict["throwdata"].damage

		f.grounded = false
		f.invincible = false
		f.state_dict["hitstun"] = 120
		return moveset.air_hitstun if f.health > 0 else moveset.dead

	return null


func run(f: Fighter, input: Dictionary) -> void:
	f.invincible = true

	f.vel.x = 0
	if f.grounded:
		f.vel.y = 0
	else:
		f.vel.y = f.fighter_gravity

	# TODO: HACK: WARNING: IDK: Port priority matters!
	# var opponent = f.get_node(f.opponent_path)
	# f.fixed_position.x = (
	# 	opponent.fixed_position.x
	# 	+ (f.state_dict["throwdata"].release_position_x << 16)
	# )
	# f.fixed_position.y = (
	# 	opponent.fixed_position.y
	# 	- (f.state_dict["throwdata"].release_position_y << 16)
	# )


func exit(f: Fighter) -> void:
	f.invincible = false


func animation(f: Fighter) -> String:
	return "Hitstun"


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null


func attack_level() -> int:
	return 8765309
