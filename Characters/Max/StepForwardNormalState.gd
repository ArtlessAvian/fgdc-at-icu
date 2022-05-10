extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"

export(int) var step_vel = 20 << 16
export(int) var step_time = 8


func enter(f: Fighter) -> void:
	.enter(f)


func run(f: Fighter, input: Dictionary) -> void:
	.run(f, input)
	if f.state_time < step_time:
		# print("steppin")
		f.vel.x = int(sign(f.fixed_scale.x)) * step_vel
