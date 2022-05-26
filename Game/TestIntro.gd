extends Label

func start():
	# TODO: Testing playing animations
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.0), "timeout")

	self.text = "The clock says 90 seconds"
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.0), "timeout")
	
	self.text = "Duel 1"
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.0), "timeout")
	
	self.text = "Fight!"
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.0), "timeout")