extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"


func enter(f: Fighter) -> void:
	.enter(f)
	f.state_dict["footdive_hit"] = false


func run(f: Fighter, input: Dictionary) -> void:
	.run(f, input)

	if not f.state_dict["footdive_hit"]:
		if f.state_time < attack_data.startup:
			f.vel.x = 0
			f.vel.y = f.fighter_gravity
		else:
			if attack_level() != 1:
				f.vel.x = (20 << 16) * int(sign(f.fixed_scale.x))
				f.vel.y = (-6 << 16) + f.fighter_gravity
			else:
				# heavy
				f.vel.x = (6 << 16) * int(sign(f.fixed_scale.x))
				f.vel.y = (-20 << 16) + f.fighter_gravity

		if f.state_dict.last_attack_contact == f.get_node("Hitboxes").attack_number:
			f.vel.x = (-5 << 16) * int(sign(f.fixed_scale.x))
			f.vel.y = (5 << 16) + f.fighter_gravity
			f.state_dict["footdive_hit"] = true

	else:
		for child in f.get_node("Hitboxes").get_children():
			child.disabled = true
