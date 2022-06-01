extends "res://addons/FGDC-Datatypes/State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var taxi = f.get_node_or_null(f.state_dict["my_taxi"])

	if taxi == null or taxi.hit:
		f.grounded = false
		f.state_dict.hitstun = 45
		f.vel.y = 30 << 16
		f.invincible = false
		return moveset.air_hitstun

	return null


func run(f: Fighter, input: Dictionary) -> void:
	var taxi = f.get_node_or_null(f.state_dict["my_taxi"])
	if taxi != null:
		f.fixed_position.x = taxi.fixed_position.x
		f.fixed_position.y = taxi.fixed_position.y
	f.vel.x = 0
	f.vel.y = 0 if f.grounded else f.fighter_gravity
	f.invincible = true


func exit(f: Fighter) -> void:
	f.invincible = false


func animation(f: Fighter) -> String:
	return "Crouch"


func attack_level() -> int:
	return 10
