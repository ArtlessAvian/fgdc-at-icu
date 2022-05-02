extends State

export(int) var impulse = 15
export(Resource) var attack_data = null


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.light and not input.heavy:
		return false

	if f.state in [moveset.walk, moveset.crouch]:
		if f.get_node("InputHistory").detect_dp(f.fixed_scale.x < 0, 17):
			f.vel.y = (impulse << 16) + ((5 << 16) if input.heavy else 0)
			f.vel.x = int(sign(f.fixed_scale.x)) * 5 << 16
			f.grounded = false
			f.get_node("Hitboxes").new_attack()
			print("Bestest Ken")
			return true

	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > 111:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))
	f.invincible = f.state_time < 30


func animation(f: Fighter) -> String:
	return "DP"
