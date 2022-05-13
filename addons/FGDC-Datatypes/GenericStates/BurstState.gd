extends "../State.gd"


func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	# TODO: Actual transition out
	return moveset.walk


func run(f: Fighter, input: Dictionary) -> void:
	print("Burst!!!")
	pass


# TODO: Proper burst animations
func animation(f: Fighter) -> String:
	return "Crouch"
