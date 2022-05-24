extends "res://addons/FGDC-Datatypes/State.gd"

const TAXI_SCENE = preload("res://Characters/Snail/Taxi.tscn")
export(bool) var is_heavy = false


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.light and not is_heavy:
		return false
	if not input.heavy and is_heavy:
		return false

	if (
		f.state in [moveset.walk, moveset.crouch, moveset.jump] + moveset.all_attacks()
		and f.state.attack_level() < self.attack_level()
	):
		if f.get_node("InputHistory").detect_qcb(f.fixed_scale.x < 0, 17):
			f.vel.x = 0
			f.get_node("Hitboxes").new_attack()

			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time >= 35:
		if not input.light:
			return moveset.walk
		for state in moveset.movement:
			if "Ride" in state.resource_path:
				return state

	return null


func run(f: Fighter, input: Dictionary) -> void:
	# if f.state_time == (59 if is_heavy else 30):
	# 	for i in range(-3, 7, 2):
	# 		var angle = i * 2860 * (1 if f.grounded else -1)

	# var i = f.state_time - (50 if is_heavy else 30)
	# if 0 <= i and i < 10 and i % 2 == 0:
	# 	var angle = (i - 3) * 2860 * (1 if f.grounded else -1)
	if f.state_time == 0:
		var taxi = SyncManager.spawn(
			"Taxi",
			f.get_parent().get_node("Spawned"),
			TAXI_SCENE,
			{
				"position_x": f.fixed_position.x,
				"position_y": f.fixed_position.y,
				"is_heavy": is_heavy,
				"flip": f.fixed_scale.x < 0,
				"is_p2": f.is_p2,
			}
		)

		f.state_dict["my_taxi"] = taxi.get_path()

	f.vel.x = 0


func animation(f: Fighter) -> String:
	return "Walk"


func attack_level() -> int:
	return 10
