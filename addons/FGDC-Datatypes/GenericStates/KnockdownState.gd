extends "../State.gd"


export (int) var knockdown_timer = 0 

func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	return false

func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	return null

func run(f: Fighter, input: Dictionary) -> void:
	pass
	
func animation(f: Fighter) -> String:
	return ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
