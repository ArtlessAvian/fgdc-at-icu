extends "../State.gd"

export(int) var damage = 1
# export(int) var length = 8
export(String) var animation_name


func transition(f: Fighter, moveset: Moveset, input: Dictionary) -> State:
	if f.state_time > f.get_node("AnimationPlayer").get_animation(animation_name).length:
		return moveset.walk if f.grounded else moveset.jump
	return null


func run(f: Fighter, input: Dictionary) -> void:
	# Controlled mostly by the animation player, but custom code here is fine too.
	# f.get_node("Hitboxes/SGCollisionShape2D").disabled = not f.state_time in [5, 6, 7]

	pass


func animation(f: Fighter) -> String:
	return animation_name


func attack_level() -> int:
	return 0
