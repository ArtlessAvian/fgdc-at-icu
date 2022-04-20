extends Node
tool

# export(bool) var save_hitboxes = false

var last_t = -120312
var last_animation = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process(Engine.editor_hint)
	$Label2.visible = Engine.editor_hint
	$Label2.text = "No attack loaded!"


func _process(delta):
	var ani_player = get_node("../AnimationPlayer")
	var moveset = get_parent().moveset

	var attack_data: AttackData = get_attack_data(ani_player, moveset)
	if attack_data == null:
		$Label2.text = "No attack loaded!"
		# save_hitboxes = false
		return

	var t = ani_player.current_animation_position
	if ani_player.assigned_animation != last_animation or t != last_t:
		last_animation = ani_player.assigned_animation
		last_t = t
		on_animation_scrub(ani_player, attack_data, t)

	# if save_hitboxes:
	# 	save_hitboxes = false
	# 	on_save_hitboxes(t, attack_data)


func on_animation_scrub(ani_player, attack_data, t):
	attack_data.write_hitbox_positions(t, get_node("../Hitboxes"))

	$Label2.text = attack_data.resource_path

	$Label2.text += "\n"

	var current = attack_data
	var current_t = 0
	while current != null:
		$Label2.text += str(current.startup) + " (" + str(current.active) + ") "
		current = current.followup
	$Label2.text += str(attack_data.recovery)

	$Label2.text += "\n"

	var ani_len = round(ani_player.get_animation(ani_player.assigned_animation).length)
	var data_len = attack_data.animation_length()
	if ani_len < data_len:
		$Label2.text += (
			"Animation too short! Need "
			+ str(data_len - ani_len)
			+ " more frames!"
		)
	if ani_len > data_len:
		$Label2.text += (
			"Animation too long! Need "
			+ str(ani_len - data_len)
			+ " fewer frames!"
		)


# func on_save_hitboxes(t, attack_data):
# 	var hitdata = attack_data.get_hitdata(t)
# 	var hitboxes = get_node("../Hitboxes").get_children()

# 	while len(hitdata.hitbox_placement) < len(hitboxes) * 4:
# 		hitdata.hitbox_placement.append(0)

# 	for i in range(len(hitboxes)):
# 		var hitbox = hitboxes[i]
# 		hitdata.hitbox_placement[4 * i + 0] = hitbox.fixed_position.x >> 16
# 		hitdata.hitbox_placement[4 * i + 1] = hitbox.fixed_position.y >> 16
# 		hitdata.hitbox_placement[4 * i + 2] = hitbox.shape.extents.x >> 16
# 		hitdata.hitbox_placement[4 * i + 3] = hitbox.shape.extents.y >> 16

# 	$Label2.text += "\n Saved!"


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
