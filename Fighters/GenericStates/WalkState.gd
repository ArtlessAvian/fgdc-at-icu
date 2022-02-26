extends "../State.gd"

export(int) var speed


func transition(f: Fighter, moveset: Moveset) -> State:
	if f.grounded:
		if Input.is_action_pressed("ui_up"):
			f.grounded = false

			if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right"):
				if Input.is_action_pressed("ui_left") and f.vel.x > -5 * 65565:
					f.vel.x = -5 * 65565
				if Input.is_action_pressed("ui_right") and f.vel.x < 5 * 65565:
					f.vel.x = 5 * 65565

			f.vel.y -= 12 * 65565

			return moveset.jump
	return self


func run(f: Fighter) -> void:
	if f.grounded:
		f.vel.x = 0
		if Input.is_action_pressed("ui_left"):
			f.vel.x -= 5 * 65565
		if Input.is_action_pressed("ui_right"):
			f.vel.x += 5 * 65565


func animation(f: Fighter) -> String:
	return "Walk" if f.vel.x != 0 else "Idle"
