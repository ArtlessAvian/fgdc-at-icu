extends SGFixedNode2D

const OFFSET_X = 90 * 65536
const OFFSET_Y = 90 * 65536

var flip = false
var lifetime = 0
var is_heavy = false
var is_air = false


func _network_spawn(data: Dictionary):
	self.flip = data.flip
	self.is_heavy = data.is_heavy
	self.is_air = data.is_air
	self.lifetime = 0

	self.fixed_position.x = data.position_x
	self.fixed_position.y = data.position_y
	self.fixed_position.x += OFFSET_X * (-1 if flip else 1)
	self.fixed_position.y -= OFFSET_Y

	$Hitboxes.facing = -1 if self.flip else 1
	$Hitboxes.set_player(data.is_p2, true)
	$Hurtboxes.set_player(data.is_p2, true)

	add_to_group("network_sync")


func _network_preprocess(input: Dictionary) -> void:
	if is_heavy:
		var thirty_deg = SGFixed.asin(1 << 15)
		var dx = 9 * SGFixed.cos(thirty_deg)
		var dy = 9 * SGFixed.sin(thirty_deg)
		self.fixed_position.x += dx * (-1 if flip else 1)
		self.fixed_position.y += dy * (1 if self.is_air else -1)
	else:
		self.fixed_position.x += (9 << 16) * (-1 if flip else 1)

	get_node("Node2D/Sprite").rotation_degrees = lifetime * 19
	lifetime += 1


# The game collides all hitboxes and hurtboxes!


func _network_postprocess(input: Dictionary) -> void:
	if abs(fixed_position.x) > 1000 * 65536:
		SyncManager.despawn(self)
	if get_node("Hurtboxes").hit_hitdata != null:
		SyncManager.despawn(self)


func _save_state() -> Dictionary:
	return {x = fixed_position.x, y = fixed_position.y, lifetime = lifetime}


func _load_state(save: Dictionary) -> void:
	fixed_position.x = save.x
	fixed_position.y = save.y
	lifetime = save.lifetime

	$Hitboxes.sync_to_physics_engine()


func _on_Hitboxes_on_contact(blocked: bool, hitstop: int):
	SyncManager.despawn(self)
