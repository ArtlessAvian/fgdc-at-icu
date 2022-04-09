extends SGFixedNode2D

# ignore that it isn't constant.
const OFFSET_X = 45 * 65536
const OFFSET_Y = 45 * 65536

var flip = false


func _network_spawn(data: Dictionary):
	self.fixed_position = data.position
	self.fixed_position.x += OFFSET_X
	self.fixed_position.y -= OFFSET_Y

	self.flip = data.flip


func _network_process(input: Dictionary) -> void:
	self.fixed_position.x += 3 * 65536 * (-1 if flip else 1)

	if abs(fixed_position.x) > 1000 * 65536:
		SyncManager.despawn(self)


func _save_state() -> Dictionary:
	# saving state-machine-state in rollback-state should be fine, they're mostly constants.
	# var save =
	return {
		x = fixed_position.x,
		y = fixed_position.y,
	}
	# return save


func _load_state(save: Dictionary) -> void:
	fixed_position.x = save.x
	fixed_position.y = save.y

	# $Hitboxes.sync_to_physics_engine()
