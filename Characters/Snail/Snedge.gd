extends SGFixedNode2D

export(int) var stall_time = 15
export(int) var offset_x = -200 << 16
export(int) var dash_distance = 800 << 16
export(int) var dash_time = 20
export(int) var slicey_time = 20
export(int) var exit_time = 50

var flip = false
var lifetime = 0
var origin_x = 0

var im_hit = false
var snail = null


func _network_spawn(data: Dictionary):
	self.lifetime = 0
	self.flip = data.flip
	self.snail = data.snail

	self.origin_x = data.position_x
	self.origin_x += offset_x * (-1 if self.flip else 1)

	self.fixed_scale.x = (-1 if self.flip else 1) * (1 << 16)

	$Hitboxes.facing = -1 if self.flip else 1

	# snedge hits snail too
	# $Hitboxes.set_player(data.is_p2, true)
	# snedge breaks enemy projectiles
	$ProjectileBreaker.collision_layer = 0b0100 ^ (0b1100 if data.is_p2 else 0b0000)

	# snedge is hit by fighters, but not projectiles
	$Hurtboxes.set_player(data.is_p2, false)
	# $Hurtboxes.collision_mask =

	add_to_group("network_sync")

	_network_preprocess({})


func _network_preprocess(input: Dictionary) -> void:
	if im_hit:
		return

	if lifetime < stall_time:
		self.fixed_position.x = self.origin_x
	elif lifetime < stall_time + dash_time:
		var t = (lifetime - stall_time) << 16
		var aaa = SGFixed.mul(dash_distance, t)
		var aaaaaa = SGFixed.div(aaa, dash_time << 16)
		self.fixed_position.x = self.origin_x + aaaaaa * (-1 if self.flip else 1)

		$Node2D/Snedge.rotation_degrees = 1800.0 * (lifetime - stall_time) / dash_time
	else:
		self.fixed_position.x = self.origin_x + dash_distance * (-1 if self.flip else 1)
		$Node2D/Snedge.rotation_degrees = 0

	$Hitboxes/SGCollisionShape2D.disabled = (lifetime != stall_time + dash_time + slicey_time)
	$ProjectileBreaker/SGCollisionShape2D.disabled = (
		lifetime
		>= stall_time + dash_time + slicey_time
	)
	$SnedgeSlice.visible = (
		(lifetime >= stall_time + dash_time + slicey_time - 2)
		and (lifetime <= stall_time + dash_time + slicey_time + 2)
	)

	lifetime += 1


# The game collides all hitboxes and hurtboxes!


func _network_postprocess(input: Dictionary) -> void:
	if $Hurtboxes.hit_hitdata != null:
		on_hit()

	if lifetime > stall_time + dash_time + exit_time:
		SyncManager.despawn(self)


func on_hit():
	if im_hit:
		return
	im_hit = true
	print("ouchy")
	snail.state_dict["SnedgeIsDedge"] = true

	$Hitboxes/SGCollisionShape2D.disabled = true
	$Hurtboxes/SGCollisionShape2D.disabled = true
	$ProjectileBreaker/SGCollisionShape2D.disabled = true
	$Node2D/Snedge.visible = false
	$Deadge.visible = true
	$SnedgeSlice.visible = false


func _save_state() -> Dictionary:
	return {
		lifetime = lifetime,
		im_hit = im_hit,
	}


func _load_state(save: Dictionary) -> void:
	lifetime = save.lifetime
	im_hit = save.im_hit

	$Hitboxes/SGCollisionShape2D.disabled = im_hit
	$Hurtboxes/SGCollisionShape2D.disabled = im_hit
	$Hurtboxes/SGCollisionShape2D.disabled = im_hit
	$Hitboxes.sync_to_physics_engine()
	$Hurtboxes.sync_to_physics_engine()


func _on_Hitboxes_on_contact(blocked: bool, hitstop):
	# on_hit()
	pass
