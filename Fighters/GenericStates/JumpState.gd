extends "../State.gd"

export(int) var speed


func transition(f: Fighter, moveset: Moveset) -> State:
	if Input.is_action_just_pressed("ui_up"):
		if f.air_actions > 0:
			if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right"):
				if Input.is_action_pressed("ui_left") and f.vel.x > -5 * 65536:
					f.vel.x = -5 * 65536
				if Input.is_action_pressed("ui_right") and f.vel.x < 5 * 65536:
					f.vel.x = 5 * 65536

			f.vel.y = -6 * 65536
			f.air_actions -= 1
			return self

	return self


func run(f: Fighter) -> void:
	print("aekljfawelkj1")
	pass


func animation(f: Fighter) -> String:
	return "Jump"
