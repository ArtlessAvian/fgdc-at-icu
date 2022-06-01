extends SGFixedNode2D

export(int) var arrival = 30
export(int) var stall_time = 10
# export(int) var deacc = 30
# export(int) var acc = 30

var flip = false
var lifetime = 0
var origin_x = 0

var hit = false

const HONK_SOUND = preload("res://Characters/Snail/Assets/mixkit-car-horn-718.wav")


func _network_spawn(data: Dictionary):
	self.lifetime = 0
	self.flip = data.flip

	self.origin_x = data.position_x

	self.fixed_scale.x = (-1 if self.flip else 1) * (1 << 16)

	$Hitboxes.facing = -1 if self.flip else 1
	$Hitboxes.set_player(data.is_p2, true)
	$Hurtboxes.set_player(data.is_p2, true)

	add_to_group("network_sync")

	$AnimatedSprite.play("default")
	$AnimatedSprite2.play("default")
	$AnimatedSprite3.play("default")

	_network_preprocess({})

	SyncManager.play_sound(
		str(get_path()) + ":honk",
		HONK_SOUND,
		{position = Vector2(fixed_position.x >> 16, 0), pitch_scale = 1, volume_db = 10}
	)


func _network_preprocess(input: Dictionary) -> void:
	if hit:
		lifetime += 1
		return

	var offset
	if lifetime < arrival:
		var t = lifetime - arrival
		offset = -t * t
	elif lifetime < arrival + stall_time:
		offset = 0
	else:
		var t = lifetime - arrival - stall_time
		offset = t * t

	self.fixed_position.x = (origin_x + offset * (3 << 15) * (-1 if flip else 1))
	self.fixed_position.y = -(offset * (3 << 15))

	lifetime += 1


# The game collides all hitboxes and hurtboxes!


func _network_postprocess(input: Dictionary) -> void:
	if fixed_position.x * (-1 if flip else 1) > 1000 << 16:
		on_hit()

	if $Hurtboxes.hit_hitdata != null:
		on_hit()

	if lifetime > 300:
		SyncManager.despawn(self)


const EXPLOSION = preload("res://Sounds/boom_hit_1.wav")


func on_hit():
	if hit:
		return
	hit = true
	$Hitboxes/SGCollisionShape2D.disabled = true
	$Hurtboxes/SGCollisionShape2D.disabled = true
	$AnimatedSprite.play("explode")
	$AnimatedSprite2.play("explode")
	$AnimatedSprite3.play("explode")
	$Sprite.visible = false
	# SyncManager.despawn(self)
	SyncManager.play_sound(
		str(get_path()) + ":hit", EXPLOSION, {position = position, pitch_scale = 1, volume_db = 10}
	)


func _save_state() -> Dictionary:
	return {
		lifetime = lifetime,
		hit = hit,
	}


func _load_state(save: Dictionary) -> void:
	lifetime = save.lifetime
	hit = save.hit

	$Hitboxes/SGCollisionShape2D.disabled = hit
	$Hitboxes.sync_to_physics_engine()


func _on_Hitboxes_on_contact(blocked: bool, hitstop):
	on_hit()
