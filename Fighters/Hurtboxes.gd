extends SGArea2D
class_name Hurtboxes
tool

# Information here is only useful within a frame, so no need to save.
var hit_flag = false
var hitstun = 20

# Save this
var hurty = {}  # please name this something better soon.


func _ready():
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		var shape: SGRectangleShape2D = child.shape
		child.shape = child.shape.duplicate(true)


const color_disabled = Color8(127, 127, 127, 127)


func _process(delta):
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		# child.visible = not child.disabled
		if child.disabled:
			child.self_modulate = color_disabled
		else:
			child.self_modulate = Color.white


func collide_hitboxes():
	hit_flag = false

	var my_hitboxes: SGArea2D = $"../Hitboxes"

	for hitboxes in self.get_overlapping_areas():
		if hitboxes == my_hitboxes:
			continue

		if hitboxes is Hitboxes:
			var pair = hitboxes.attack_number * 100 + hitboxes.multihit
			var key = hitboxes.get_parent().is_p2  # todo make not garbo
			if (not key in hurty) or pair != hurty[key]:
				hurty[key] = pair
				self.hit_flag = true

				# print("accepted ", SyncManager.current_tick)
			else:
				# print("rejected ", SyncManager.current_tick)
				pass


func _save_state() -> Dictionary:
	return {
		# hit_flag = hit_flag,
		hurtyy = hurty.duplicate(true),
	}


func _load_state(save: Dictionary) -> void:
	hit_flag = false
	hurty = save.hurtyy.duplicate(true)

	sync_to_physics_engine()
