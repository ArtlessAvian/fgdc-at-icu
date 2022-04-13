extends Node
tool


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process(Engine.editor_hint)
	$Label2.visible = Engine.editor_hint
	$Label2.text = "No attack loaded!"


func _process(delta):
	var ani_player = get_node("../AnimationPlayer")
	var moveset = get_parent().moveset

	var attack_data = get_attack_data(ani_player, moveset)
	if attack_data == null:
		$Label2.text = "No attack loaded!"
		return

	$Label2.text = attack_data.resource_path

	var t = ani_player.current_animation_position

	get_node("../Hitboxes/SGCollisionShape2D").disabled = (
		t < attack_data.startup
		or t >= attack_data.startup + attack_data.active
	)
	# print(ani_player.current_animation_position)


func get_attack_data(ani_player: AnimationPlayer, moveset: Moveset):
	if ani_player.assigned_animation == "":
		return null

	if moveset == null:
		return null

	var attack_data = null

	for state in moveset.all_states():
		var some_data = state.get("attack_data")
		if (
			some_data != null
			and some_data.animation_name == ani_player.assigned_animation
		):
			attack_data = some_data
			break

	return attack_data
