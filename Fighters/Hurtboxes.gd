extends SGArea2D
class_name Hurtboxes
tool

# Information here is only useful within a frame, so no need to save.
var hit_flag = false
var hitstun = 20
var damage 		# Allows Fighter to know how much damage it took when hit

# Save this
var hurty = {}  # please name this something better soon.


func _ready():
	for uncast in get_children():
		var child: SGCollisionShape2D = uncast
		var shape: SGRectangleShape2D = child.shape
		child.shape = child.shape.duplicate(true)

	add_to_group("hurtboxes")
	add_to_group("network_sync")


# no reason to toggle, just once at the start!
func toggle_player():
	collision_mask ^= 0b11


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

	for hitboxes in self.get_overlapping_areas():
		if hitboxes is Hitboxes:
			var pair = hitboxes.attack_number * 100 + hitboxes.multihit
			var key = hitboxes.get_parent().name  # todo make not garbo
			if (not key in hurty) or pair != hurty[key]:
				# TODO: Can get hit multiple times in one frame by same hitbox
				damage = hitboxes.get_hit_data().damage

				hurty[key] = pair
				self.hit_flag = true
				hitboxes.emit_signal("on_hit")

				break  # only one thing can hit you at one time.

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
