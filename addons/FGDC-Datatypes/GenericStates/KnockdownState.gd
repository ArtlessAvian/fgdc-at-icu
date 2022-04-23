extends "../State.gd"


export (int) var knockdown_timer = 30 

func transition_into(f: Fighter, moveset: Moveset, input: Dictionary) -> bool:
	if f.grounded and f.get_node("Hurtboxes").hit_hitdata.knockdown:
		f.invincible = true
		return true
	return false

func transition_out(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	print("dude you look huge")
	if f.state_time > knockdown_timer:
		f.invincible = false
		print("transitioned out")
		return moveset.walk
	
	return null

func run(f: Fighter, input: Dictionary) -> void:
	print("IM IN KNOCKDOWN")
	pass
	
func animation(f: Fighter) -> String:
	return "Hitstun"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
