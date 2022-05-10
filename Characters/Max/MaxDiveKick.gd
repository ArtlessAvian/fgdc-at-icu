extends State

export(int) var impulse = -3
export(int) var attack_level = 6
export(bool) var jump_cancellable = false

export(Resource) var attack_data = null


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.grounded:
		return false
	if not input.light:
		return false

	if f.state in [moveset.jump, moveset.j_light, moveset.j_heavy]:
		if f.get_node("InputHistory").detect_downdown(f.fixed_scale.x < 0, 17):
			f.fighter_gravity = 0
			f.vel.y = (impulse << 16)
			f.vel.x = int(sign(f.fixed_scale.x)) * 8 << 16
			f.grounded = false
			f.get_node("Hitboxes").new_attack()
			return true

	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.grounded:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))


func animation(f: Fighter) -> String:
	return "Divekick"
