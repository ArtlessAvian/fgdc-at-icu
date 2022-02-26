extends Label


func _process(delta):
	var f: Fighter = get_parent()

	var eee = str(f.state.get_instance_id())
	eee += "\n" + str(f.state_time)
	eee += "\n" + str(f.air_actions)

	self.text = eee
