extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"

const HIDDEN_MISSILE_SCENE = preload("res://Characters/Lippo/HiddenMissile.tscn")

export(bool) var is_light = false


func enter(f: Fighter) -> void:
	.enter(f)


func run(f: Fighter, input: Dictionary) -> void:
	.run(f, input)
	if f.state_time == attack_data.startup:
		if is_light:
			f.vel.x = -int(sign(f.fixed_scale_x)) * 15 << 16
			f.vel.y = int(max(f.vel.y, 5 << 16))
			f.get_node("Visual/JLightEffect").restart()
		else:
			f.vel.y = int(min(f.vel.y, -15 << 16))
			f.vel.x = -int(sign(f.fixed_scale_x)) * 15 << 16
			f.get_node("Visual/JHeavyEffect").restart()

		f.state_dict["velx"] = f.vel.x
		f.state_dict["vely"] = f.vel.y

	elif attack_data.startup <= f.state_time and f.state_time < attack_data.startup + 5:
		# f.vel.x = 0
		# f.vel.y = f.fighter_gravity
		f.vel.x = f.state_dict["velx"]
		f.vel.y = f.state_dict["vely"]

	elif f.state_time == attack_data.startup + 5:
		f.vel.x = f.state_dict["velx"]
		f.vel.y = f.state_dict["vely"]
