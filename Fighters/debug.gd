extends Label


func _process(delta):
	var f: Fighter = get_parent().get_parent()

	var eee = ""
	if f.state != null:
		var state: String = f.state.resource_path
		var slice = state.find_last("/") + 1
		eee += state.substr(slice)

		eee += " ("

		var script: String = f.state.script.resource_path
		var slice2 = script.find_last("/") + 1
		eee += script.substr(slice2)
		eee += ")"

	# eee += "\n" + str(f.get_node("InputHistory").history)
	eee += "\n" + f.get_node("AnimationPlayer").current_animation
	eee += "\n" + str(f.state_time)
	eee += "\n" + str(f.state_dict)
	eee += "\n" + str(f.get_node("InputHistory")._stick_history)

	self.text = eee

	get_parent().scale.x = sign(f.fixed_scale.x)
