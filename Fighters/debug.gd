extends Label


func _process(delta):
	var f: Fighter = get_parent().get_parent()

	var eee = ""
	if f.state != null:
		var file: String = f.state.script.resource_path
		var substr = file.find_last("/") + 1
		eee += file.substr(substr)
		
	eee += "\n" + str(f.get_node("InputHistory").history)
	eee += "\n" + str(f.state_dict)
	eee += "\n" + str(f.state_time)

	self.text = eee

	get_parent().scale.x = sign(f.fixed_scale.x)
