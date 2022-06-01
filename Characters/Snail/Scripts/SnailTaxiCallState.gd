extends "res://addons/FGDC-Datatypes/State.gd"

const TAXI_SCENE = preload("res://Characters/Snail/Taxi.tscn")


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.light:
		return false

	if (
		f.state in [moveset.walk, moveset.crouch, moveset.jump] + moveset.all_attacks()
		and f.state.attack_level() < self.attack_level()
	):
		if f.get_node("InputHistory").detect_charge_forward(f.fixed_scale.x < 0, 17, 30):
			f.vel.x = 0
			f.get_node("Hitboxes").new_attack()

			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time >= 20:
		var jump = transition_into_jump(f, moveset, input)
		if jump != null:
			return jump

	if f.state_time >= 35:
		var taxi = f.get_node_or_null(f.state_dict["my_taxi"])
		if taxi == null or taxi.hit:
			return moveset.walk
		for state in moveset.movement:
			if "Ride" in state.resource_path:
				return state

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time == 0:
		var taxi = SyncManager.spawn(
			"Taxi",
			f.get_parent().get_node("Spawned"),
			TAXI_SCENE,
			{
				"position_x": f.fixed_position.x,
				"flip": f.fixed_scale.x < 0,
				"is_p2": f.is_p2,
			}
		)

		f.state_dict["my_taxi"] = taxi.get_path()

	f.vel.x = 0


func animation(f: Fighter) -> String:
	return "HeyTaxi"


func attack_level() -> int:
	return 10
