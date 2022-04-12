extends Node
tool


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process(Engine.editor_hint)


func _process(delta):
	var ani_player = get_node("../AnimationPlayer")
	if ani_player.assigned_animation == "":
		return

	var moveset = get_parent().moveset
	if moveset == null:
		return

	var attack_data = null
	for state in moveset.all_states():
		var some_data = state.get("attack_data")
		if (
			some_data != null
			and some_data.animation_name == ani_player.assigned_animation
		):
			attack_data = some_data
			break
	if attack_data == null:
		return

	var t = ani_player.current_animation_position

	get_node("../Hitboxes/SGCollisionShape2D").disabled = (
		t < attack_data.startup
		or t >= attack_data.startup + attack_data.active
	)
	print(attack_data.resource_path)
	# print(ani_player.current_animation_position)
