extends State

export(int) var impulse = 40
export(int) var attack_level = 6
export(bool) var jump_cancellable = false
export var heavy = false

export(Resource) var attack_data = null


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.light and not input.heavy:
		return false

	if (
		f.state in [moveset.walk, moveset.crouch] + moveset.all_attacks()
		and f.state.attack_level() < self.attack_level()
	):
		if f.get_node("InputHistory").detect_qcb(f.fixed_scale.x < 0, 17):
			f.vel.x = 0
			f.get_node("Hitboxes").new_attack()

			if input.heavy:
				heavy = true
			return true

	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > 40:
		return moveset.walk

	# lolol what if it jump canceled
	# if f.get_node("Hitboxes").attack_number == f.state_dict.get("last_attack_contact"):
	# 	var jump = transition_into_jump(f, moveset, input)
	# 	if jump != null:
	# 		return jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))
	if heavy:
		if f.state_time < 15:
			f.vel.x = 0
		elif f.state_time < 21:
			f.vel.x = (impulse * 2 * (-1 if f.fixed_scale.x < 0 else 1)) << 16
		else:
			f.vel.x = 0
	else:
		if f.state_time < 11:
			f.vel.x = 0
		elif f.state_time < 17:
			f.vel.x = (impulse * (-1 if f.fixed_scale.x < 0 else 1)) << 16
		else:
			f.vel.x = 0


func animation(f: Fighter) -> String:
	return "DashPunch"


func attack_level() -> int:
	return attack_level
