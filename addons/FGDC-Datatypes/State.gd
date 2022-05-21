extends Resource
class_name State


# Define transitions from all states IN.
# Has priority over transition
func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


# Define transitions from this state OUT.
# Has less priority over transition_into
func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	return null


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	for state in moveset.all_states():
		# print(moveset.all_states())
		if state.transition_into(f, moveset, input):
			# print(state.script.resource_path)
			return state
	return transition_out(f, moveset, input)


# dunno what params i want for this
func enter(f: Fighter) -> void:
	return


func run(f: Fighter, input: Dictionary) -> void:
	return


func animation(f: Fighter) -> String:
	return "Idle"


# Interface


func attack_level() -> int:
	return -1


func can_block() -> bool:
	return false


# Returns a state to transition to, or null to not transition
# By default, just puts you on the ground and transitions to walk
func do_landing(f: Fighter, moveset: Moveset) -> void:
	f.fixed_position.y = 0
	f.vel.y = 0
	f.grounded = true
	f.face_opponent()


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return moveset.walk


func ignore_collision() -> bool:
	return false


# Helpers


func transition_into_jump(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if input.stick_y > 0:
		return moveset.prejump

	return null


func transition_into_double_jump(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.air_actions > 0 and f.state_dict.let_go == true:
		if input.stick_y > 0:
			if input.stick_x == 0:
				f.vel.x = 0
			elif input.stick_x < 0 and f.vel.x > -moveset.jump.horizontal_speed:
				f.vel.x = -moveset.jump.horizontal_speed
			elif input.stick_x > 0 and f.vel.x < moveset.jump.horizontal_speed:
				f.vel.x = moveset.jump.horizontal_speed

			f.vel.y = moveset.jump.double_jump_impulse
			f.air_actions -= 1
			return moveset.jump
	return null


func transition_into_attack(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if not f.state_dict.has("last_attack_hit"):
		f.state_dict.last_attack_hit = -1

	if f.state in moveset.all_normals():
		if f.get_node("Hitboxes").attack_number != f.state_dict.last_attack_contact:
			return null

	if not f.grounded:
		if input.heavy and self.attack_level() < moveset.j_heavy.attack_level():
			return moveset.j_heavy
		if input.light and self.attack_level() < moveset.j_light.attack_level():
			return moveset.j_light
		return null

	if input.stick_y < 0:
		if input.heavy and self.attack_level() < moveset.c_heavy.attack_level():
			return moveset.c_heavy
		if input.light and self.attack_level() < moveset.c_light.attack_level():
			return moveset.c_light

	# not grounded, not crouching
	if input.heavy and self.attack_level() < moveset.heavy.attack_level():
		return moveset.heavy
	if input.light and self.attack_level() < moveset.light.attack_level():
		return moveset.light

	return null
