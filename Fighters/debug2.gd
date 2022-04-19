extends Label


func _process(delta):
	var f: Fighter = get_parent().get_parent()

	var eee = ""

	# eee += "\n" + str(f.get_node("InputHistory").history)
	eee += str(f.health) + "\n"
	eee += str(f.combo_count) + " combo!\n"

	self.text = eee

	get_parent().scale.x = sign(f.fixed_scale.x)
