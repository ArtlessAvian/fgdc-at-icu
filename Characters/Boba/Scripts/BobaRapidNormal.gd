extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"


func enter(f: Fighter) -> void:
	.enter(f)
	# f.state_dict["pushback"] = -2


func run(f: Fighter, input: Dictionary) -> void:
	.run(f, input)

	# if f.grounded and 5 <= f.state_time and f.state_time < 10:
	if f.grounded and f.state_time < 10:
		f.vel.x -= (5 << 16) * sign(f.fixed_scale.x)

	# if f.state_dict["pushback"] == -2:
	# 	if f.get_node("Hitboxes").attack_number == f.state_dict.last_attack_contact:
	# 		f.state_dict["pushback"] = 5 if f.grounded else 1
	# if f.state_dict["pushback"] > 0:
	# 	f.vel.x -= (5 << 16) * sign(f.fixed_scale.x)
	# 	f.state_dict["pushback"] == 0


func transition_into_attack(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if not f.state_dict.has("last_attack_hit"):
		f.state_dict.last_attack_hit = -1
	# if f.state_dict["pushback"] > 0:
	# return null

	if f.state in moveset.all_normals():
		if f.get_node("Hitboxes").attack_number != f.state_dict.last_attack_contact:
			return null

	if not f.grounded:
		if input.heavy and self.attack_level() <= moveset.j_heavy.attack_level():
			return moveset.j_heavy
		if input.light and self.attack_level() <= moveset.j_light.attack_level():
			return moveset.j_light
		return null

	if input.stick_y < 0:
		if input.heavy and self.attack_level() <= moveset.c_heavy.attack_level():
			return moveset.c_heavy
		if input.light and self.attack_level() <= moveset.c_light.attack_level():
			return moveset.c_light

	# not grounded, not crouching
	if input.heavy and self.attack_level() <= moveset.heavy.attack_level():
		return moveset.heavy
	if input.light and self.attack_level() <= moveset.light.attack_level():
		return moveset.light

	return null
