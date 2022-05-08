extends "res://addons/FGDC-Datatypes/State.gd"

export(bool) var is_heavy
export(int) var animation_time = 30
export(int) var fireball_time = 10

var fireball = load("res://Characters/Lippo/CardScene.tscn")
var air_fireball_heavy = load("res://Characters/Lippo/CardSceneHeavy.tscn")


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.state.attack_level() < attack_level():
		if (is_heavy and input.heavy) or (not is_heavy and input.light):
			if f.get_node("InputHistory").detect_qcf(f.fixed_scale.x < 0, 15):
				return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if f.grounded:
		f.vel.x = 0

	if f.state_time > animation_time:
		if f.grounded:
			return moveset.walk
		return moveset.jump

	return null


func enter(f: Fighter) -> void:
	pass


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time == fireball_time:
		SyncManager.spawn(
			"Fireball",
			f.get_parent().get_node("Spawned"),
			fireball,
			{
				"position_x": f.fixed_position.x,
				"position_y": f.fixed_position.y,
				"flip": f.fixed_scale.x < 0,
				"is_p2": f.is_p2,
				"is_heavy": is_heavy
			}
		)

	if 0 <= f.state_time and f.state_time < fireball_time + 10:
		f.vel.x = 0
		f.vel.y = f.fighter_gravity if not f.grounded else 0


func animation(f: Fighter) -> String:
	return "Fireball"


func attack_level() -> int:
	return 1
