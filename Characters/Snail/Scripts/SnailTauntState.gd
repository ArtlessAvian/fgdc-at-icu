extends "res://addons/FGDC-Datatypes/State.gd"

const BOOM = preload("res://Sounds/boom_hit_1.wav")


func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if not f.grounded:
		return false
	if not input.dash:
		return false

	if f.state in [moveset.walk, moveset.crouch, moveset.jump]:
		f.vel.x = 0
		return true

	return false


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	if not input.dash:
		return moveset.walk

	return null


func run(f: Fighter, input: Dictionary) -> void:
	if f.state_time == 45:
		SyncManager.play_sound(
			str(get_path()) + ":meme",
			BOOM,
			{position = f.position, pitch_scale = 1, volume_db = 10, bus = "SFX"}
		)
	if f.state_time >= 45:
		if f.get_node("InputHistory").button_pressed("light", 2):
			SyncManager.play_sound(
				str(get_path()) + ":meme",
				BOOM,
				{position = f.position, pitch_scale = 1, volume_db = 10, bus = "SFX"}
			)


func animation(f: Fighter) -> String:
	return "Taunt"


func attack_level() -> int:
	return 10
