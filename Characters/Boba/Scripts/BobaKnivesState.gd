extends "res://addons/FGDC-Datatypes/State.gd"

const KNIFE_SCENE = preload("res://Characters/Boba/BobaKnife.tscn")
export(bool) var is_heavy = false


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not input.light and not is_heavy:
		return false
	if not input.heavy and is_heavy:
		return false

	if (
		f.state in [moveset.walk, moveset.crouch, moveset.jump] + moveset.all_attacks()
		and f.state.attack_level() < self.attack_level()
	):
		if f.get_node("InputHistory").detect_hcb(f.fixed_scale.x < 0, 17):
			f.vel.x = 0
			f.get_node("Hitboxes").new_attack()

			return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	if f.state_time >= 60:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time == (59 if is_heavy else 30):
		for i in range(-3, 7, 2):
			var angle = i * 2860 * (1 if f.grounded else -1)

			# var i = f.state_time - (55 if is_heavy else 30)
			# if 0 <= i and i < 5:
			# 	var angle = (2 * i - 3) * 2860 * (1 if f.grounded else -1)

			SyncManager.spawn(
				"Knife",
				f.get_parent().get_node("Spawned"),
				KNIFE_SCENE,
				{
					"position_x": f.fixed_position.x,
					"position_y": f.fixed_position.y,
					"angle": angle,
					"flip": f.fixed_scale.x < 0,
					"is_p2": f.is_p2,
				}
			)

	if f.grounded:
		f.vel.y = 0
	elif f.state_time < 55:
		f.vel.y = f.fighter_gravity
	f.vel.x = 0


func animation(f: Fighter) -> String:
	return "Walk"


func attack_level() -> int:
	return 10
