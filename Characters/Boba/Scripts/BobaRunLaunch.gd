extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"


func enter(f: Fighter) -> void:
	.enter(f)
	f.face_opponent()
	f.grounded = false


func run(f: Fighter, input: Dictionary) -> void:
	.run(f, input)

	if f.state_time < 10:
		f.vel.x = (15 << 16) * sign(f.fixed_scale.x)
		f.vel.y = (15 << 16)
	elif f.state_time < 15:
		f.vel.x = (10 << 16) * sign(f.fixed_scale.x)
		f.vel.y = (10 << 16)


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null


func ignore_collision() -> bool:
	return true
