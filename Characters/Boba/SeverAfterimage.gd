extends SGFixedNode2D

var flip = false
var lifetime = 0

export(Resource) var color_ramp


func initializeee(data: Dictionary):
	self.lifetime = 0
	self.flip = data.flip

	self.fixed_position.x = data.position_x
	self.fixed_position.y = data.position_y

	self.fixed_scale.x = (-1 if data.flip else 1) << 16
	self.add_child(data.thing)

	_physics_process(13431414)
	# _network_preprocess({})


func _physics_process(delta):  #(input: Dictionary) -> void:
	lifetime += 1

	self.modulate = color_ramp.interpolate(lifetime / 30.0)

	if lifetime > 20:
		self.queue_free()
		# SyncManager.despawn(self)


func _save_state() -> Dictionary:
	return {
		lifetime = lifetime,
	}


func _load_state(save: Dictionary) -> void:
	lifetime = save.lifetime
