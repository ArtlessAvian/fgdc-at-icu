extends State

export(int) var impulse = 20
export(int) var attack_level = 6
export(bool) var jump_cancellable = false

export(Resource) var attack_data = null


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.light:
		return false

	if f.state in [moveset.walk, moveset.crouch] + moveset.all_normals():
		if f.state.attack_level() < self.attack_level():
			if f.get_node("InputHistory").detect_dp(f.fixed_scale.x < 0, 17):
				f.vel.y = impulse << 16
				f.vel.x = int(sign(f.fixed_scale.x)) * 5 << 16
				f.grounded = false
				f.get_node("Hitboxes").new_attack()
				return true

	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time > 111:
		return moveset.walk
	return null


func run(f: Fighter, input: Dictionary) -> void:
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))


func exit(f: Fighter) -> void:
	f.invincible = false


func animation(f: Fighter) -> String:
	return "DP"


func attack_level() -> int:
	return attack_level
