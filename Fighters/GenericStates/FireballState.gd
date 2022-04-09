extends "../State.gd"

export(int) var speed


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.state.attack_level() < attack_level():
		if input.heavy or input.light:
			if f.get_node("InputHistory").detect_motion([2, 3, 6], f.fixed_scale.x < 0, 15):
				return true
			if f.get_node("InputHistory").detect_motion([2, 6], f.fixed_scale.x < 0, 15):
				return true

	return false


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.grounded:
		f.vel.x = 0

	if f.state_time > 30:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


var fireball = load("res://Fighters/DefaultMoveset/DefaultFireball.tscn")


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time == 10:
		SyncManager.spawn(
			"Fireball",
			f.get_parent().get_node("Spawned"),
			fireball,
			{"position": f.fixed_position, "flip": f.fixed_scale.x < 0}
		)
		print("yeet")


func animation(f: Fighter) -> String:
	return "jLight"


func attack_level() -> int:
	return 10
