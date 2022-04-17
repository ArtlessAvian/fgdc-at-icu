extends "../State.gd"

# Spawns *something* at the players feet. Offset done manually.
export(PackedScene) var fireball = load("res://Fighters/DefaultMoveset/FireballScene.tscn")
export(Array, int) var motions = [[2, 3, 6], [2, 6]]
export(int) var input_frames = 15

export(bool) var is_heavy = false  # otherwise, is light
export(int) var animation_time = 30
export(int) var fireball_time = 10


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.state.attack_level() < attack_level():
		if (is_heavy and input.heavy) or (not is_heavy and input.light):
			for motion in motions:
				if f.get_node("InputHistory").detect_motion(
					motion, f.fixed_scale.x < 0, input_frames
				):
					return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.grounded:
		f.vel.x = 0

	if f.state_time > animation_time:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time == fireball_time:
		SyncManager.spawn(
			"Fireball",
			f.get_parent().get_node("Spawned"),
			fireball,
			{
				"position": f.fixed_position,
				"flip": f.fixed_scale.x < 0,
				"is_p2": f.is_p2,
				"is_heavy": is_heavy
			}
		)


func animation(f: Fighter) -> String:
	return "jLight"


func attack_level() -> int:
	return 10
