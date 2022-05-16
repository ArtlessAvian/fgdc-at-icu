extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"

export(int) var loop_limit = 5
export(int) var loop_frames = 5
export(bool) var is_heavy = false


func enter(f: Fighter) -> void:
	.enter(f)
	f.state_dict["loops"] = 0


func run(f: Fighter, input: Dictionary) -> void:
	if (input.light and not is_heavy) or (input.heavy and is_heavy):
		if f.state_time == attack_data.startup + loop_frames:
			if f.state_dict["loops"] < loop_limit:
				f.state_time = attack_data.startup
				f.get_node("Hitboxes").new_attack()  # hack, but i dont care anymore
				f.state_dict["loops"] += 1

	.run(f, input)
