extends Resource
class_name State

var land_cancels = true


# Define transitions from all states IN.
# Has priority over transition
func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	return null


func run(f: Fighter, input: Dictionary) -> void:
	return


func animation(f: Fighter) -> String:
	return "Idle"


func transition_into_jump(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.stick_y > 0:
		if input.stick_x < 0 and f.vel.x > -5 * 65536:
			f.vel.x = -5 * 65536
		if input.stick_x > 0 and f.vel.x < 5 * 65536:
			f.vel.x = 5 * 65536
		if input.stick_x == 0:
			f.vel.x = 0

		f.vel.y = 12 * 65536
		f.air_actions = moveset.air_actions
		f.grounded = false

		return moveset.jump

	return null


func transition_into_attack(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if not f.grounded:
		if input.heavy and self.attack_level() < moveset.j_heavy.attack_level():
			f.get_node("Hitboxes").new_attack()
			return moveset.j_heavy
		if input.light and self.attack_level() < moveset.j_light.attack_level():
			f.get_node("Hitboxes").new_attack()
			return moveset.j_light

	if input.stick_y < 0:
		if input.heavy and self.attack_level() < moveset.c_heavy.attack_level():
			f.get_node("Hitboxes").new_attack()
			return moveset.c_heavy
		if input.light and self.attack_level() < moveset.c_light.attack_level():
			f.get_node("Hitboxes").new_attack()
			return moveset.c_light

	# not grounded, not crouching
	if input.heavy and self.attack_level() < moveset.heavy.attack_level():
		f.get_node("Hitboxes").new_attack()
		return moveset.heavy
	if input.light and self.attack_level() < moveset.light.attack_level():
		f.get_node("Hitboxes").new_attack()
		return moveset.light

	return null


func attack_level() -> int:
	return -1
