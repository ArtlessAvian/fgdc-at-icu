extends "../State.gd"

export(Resource) var attack_data = load("res://addons/FGDC-Datatypes/StandardBurst.tres")


func ensure_not_null():
	if attack_data == null:
		attack_data = load("res://addons/FGDC-Datatypes/AttackData.gd").new()
		printerr("oh no, the " + resource_path + ", its broken")


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	# FAILSAFES.
	ensure_not_null()

	if f.state_time > 60:
		return moveset.jump
	return null


func enter(f: Fighter) -> void:
	f.grounded = false
	f.get_node("Hitboxes").new_attack()


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x = 0
	f.vel.y = f.fighter_gravity
	if f.state_time <= 10:
		f.fixed_position.y = min(f.fixed_position.y, -15 * (f.state_time << 16))

	f.invincible = f.state_time <= 30
	attack_data.write_hitbox_positions(f.state_time, f.get_node("Hitboxes"))

	var character = f.find_node("Character")
	character.modulate = Color.white


func animation(f: Fighter) -> String:
	return "Burst"


func attack_level() -> int:
	return 8765309

# func do_landing(f: Fighter, moveset: Moveset) -> void:
# 	if f.state_time > 30:
# 		f.

# func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
# 	return moveset.walk if f.state_time > 30 else null
