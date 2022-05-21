extends "res://addons/FGDC-Datatypes/State.gd"

export(int) var impulse = 25 << 16
export(int) var speed_limit = 15 << 16


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> Resource:
	var attack = transition_into_attack(f, moveset, input)
	if attack != null:
		return attack

	return null


func enter(f: Fighter) -> void:
	f.vel.y = impulse
	f.grounded = false


func run(f: Fighter, input: Dictionary) -> void:
	f.vel.x += input.stick_x * (1 << 16)

	if f.vel.x < -speed_limit:
		f.vel.x = -speed_limit
	if f.vel.x > speed_limit:
		f.vel.x = speed_limit


func animation(f: Fighter) -> String:
	return "BobaRunJump"


func ignore_collision() -> bool:
	return true
