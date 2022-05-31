extends Node2D
tool

const SWIPE = preload("res://Characters/Boba/Swipe.tscn")

export(bool) var do_the_thing: bool = false


func _process(delta):
	if do_the_thing:
		do_the_thing = false
		var noddeee = SWIPE.instance()
		add_child(noddeee)
		# noddeee = SWIPE.instance()
		# add_child(noddeee)
		# noddeee = SWIPE.instance()
		# add_child(noddeee)
