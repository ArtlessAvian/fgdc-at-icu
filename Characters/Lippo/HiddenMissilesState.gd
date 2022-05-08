extends "res://addons/FGDC-Datatypes/State.gd"

const HIDDEN_MISSILE_SCENE = preload("res://Characters/Lippo/HiddenMissile.tscn")


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	if f.state_time > f.state_dict["missile_time"] + 30:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


func enter(f: Fighter) -> void:
	f.state_dict["missile_count"] = 0
	f.state_dict["missile_time"] = 30

	# Even though this doesn't really relate to the hitboxes but whatever.
	f.get_node("Hitboxes").new_attack()

	if not f.state_dict.has("last_attack_contact"):
		f.state_dict.last_attack_contact = -1


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time >= 15 and (f.state_time - 15) % 9 == 0:
		var do_missile = f.state_dict["missile_count"] == 0
		do_missile = do_missile or input.light
		do_missile = do_missile or f.get_node("InputHistory").button_pressed_recently("light", 9)

		do_missile = do_missile and f.state_dict["missile_count"] < 8

		if do_missile:
			f.state_dict["missile_time"] = f.state_time
			f.state_dict["missile_count"] += 1

			SyncManager.spawn(
				"HiddenMissile",
				f.get_parent().get_node("Spawned"),
				HIDDEN_MISSILE_SCENE,
				{
					"position_x": f.fixed_position.x,
					"position_y": f.fixed_position.y,
					"flip": f.fixed_scale.x < 0,
					"is_p2": f.is_p2,
					"target_path": f.opponent_path,
					"owner_path": f.get_path()
				}
			)


func animation(f: Fighter) -> String:
	return "HiddenMissiles" if f.state_dict["missile_count"] > 0 else "MissilesStartup"


func attack_level() -> int:
	return 1
