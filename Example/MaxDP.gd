extends State

export(int) var impulse = 15
export(Resource) var attack_data = null


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false

	if f.state in [moveset.walk]:
		if f.get_node("InputHistory").detect_motion([6, 2, 3], f.fixed_scale.x < 0, 8):
			f.vel.y = impulse * 65536
			f.grounded = false
			return true
		if f.get_node("InputHistory").detect_motion([6, 5, 2, 3], f.fixed_scale.x < 0, 8):
			f.vel.y = impulse * 65536
			f.grounded = false
			return true

	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > 30:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))


func animation(f: Fighter) -> String:
	return "DP"
