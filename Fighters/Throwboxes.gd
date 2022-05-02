extends SGArea2D
class_name Throwboxes
tool

# This should /only/ be used by Fighters, or something with state. This has no logic, it holds onto data.
# The game should determine if the throw connects, this can help perform the throw.
# If you want to do hitgrabs, then maybe hack it into hitboxes and an attacking state.

export(Resource) var throw_data
var throw_number = 0


func _ready():
	if not Engine.editor_hint:
		for uncast in get_children():
			var child: SGCollisionShape2D = uncast
			var shape: SGRectangleShape2D = child.shape
			child.shape = child.shape.duplicate(true)

	add_to_group("throwboxes")
	add_to_group("network_sync")


func set_player(is_p2):
	collision_layer = 0b01
	if is_p2:
		collision_layer ^= 0b11


func _process(delta):
	for uncast in get_children():
		var child = uncast
		if not Engine.editor_hint:
			child.visible = not child.disabled
			child.self_modulate = Color.orange
		else:
			if child.disabled:
				child.self_modulate = Color.gray
			else:
				child.self_modulate = Color.orange

		child.position.x = child.fixed_position.x / (1 << 16)
		child.position.y = child.fixed_position.y / (1 << 16)


func set_throw_data(new_throw_data: ThrowData):
	throw_data = new_throw_data


func get_throw_data() -> ThrowData:
	return throw_data

# func negotiate_throw(thrower: Fighter, throwee: Fighter):
# 	thrower.state_dict["throw_success"] = throw_number
# 	throwee.state_dict["throw_data"] = throw_data
# 	throwee.change_to_state(throwee.moveset.get_thrown)
