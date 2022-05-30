extends "res://addons/FGDC-Datatypes/GenericStates/NormalAttackState.gd"

const AFTERIMAGE = preload("res://Characters/Boba/SeverAfterimage.tscn")


func enter(f: Fighter) -> void:
	.enter(f)
	f.face_opponent()
	f.vel.x = 0


func run(f: Fighter, input: Dictionary) -> void:
	.run(f, input)

	if f.state_time == 10:
		f.grounded = false
		f.vel.x = (10 << 16) * sign(f.fixed_scale.x)
		f.vel.y = 15 << 16

	if f.state_time > 10 and f.state_time % 3 == 0:
		# You know what? unnetworks your visual thing
		var afterimage = AFTERIMAGE.instance()
		afterimage.initializeee(
			{
				"position_x": f.fixed_position.x,
				"position_y": f.fixed_position.y,
				"thing": f.get_node("Visual").duplicate(),
				"flip": f.fixed_scale.x < 0
			}
		)
		f.get_parent().get_node("Spawned").add_child(afterimage)

		# SyncManager.spawn(
		# 	"Afterimage",
		# 	f.get_parent().get_node("Spawned"),
		# 	AFTERIMAGE,
		# 	{
		# 		"position_x": f.fixed_position.x,
		# 		"position_y": f.fixed_position.y,
		# 		"thing": f.get_node("Visual").duplicate(),
		# 		"flip": f.fixed_scale.x < 0
		# 	}
		# )


func get_landing_transition(f: Fighter, moveset: Moveset) -> State:
	return null

# func ignore_collision() -> bool:
# 	return true
