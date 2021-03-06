extends "res://addons/FGDC-Datatypes/State.gd"

const TAXI_SCENE = preload("res://Characters/Snail/Snedge.tscn")


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.light:
		return false

	if (
		f.state in [moveset.walk, moveset.crouch, moveset.jump] + moveset.all_attacks()
		and f.state.attack_level() < self.attack_level()
	):
		# as much as i think input overlap would make snail play worse
		# i think people genuinely want to play snail and not suffer
		if f.get_node("InputHistory").detect_qcb(f.fixed_scale.x < 0, 17):
			f.vel.x = 0
			f.get_node("Hitboxes").new_attack()

			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.state_time >= 20:
		return moveset.walk

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if (
		f.state_time == 0
		and not (f.state_dict.has("SnedgeIsDedge") and f.state_dict["SnedgeIsDedge"])
	):
		var persona = SyncManager.spawn(
			"Persona",
			f.get_parent().get_node("Spawned"),
			TAXI_SCENE,
			{
				"position_x": f.fixed_position.x,
				"flip": f.fixed_scale.x < 0,
				"is_p2": f.is_p2,
				"snail": f,
			}
		)
		f.state_dict["SnedgeIsDedge"] = true

	f.vel.x = 0


func animation(f: Fighter) -> String:
	return "PERSONA"


func attack_level() -> int:
	return 10
