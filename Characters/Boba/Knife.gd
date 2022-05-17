extends SGFixedNode2D

const OFFSET_X = 100 * 65536
const OFFSET_Y = 100 * 65536
const TARGET_OFFSET_Y = 100 * 65536
export(int) var KNIFE_SPEED = 22

var flip = false
var lifetime = 0
var origin_x = 0
var origin_y = 0
var angle = 0

var hit = false


func _network_spawn(data: Dictionary):
	self.lifetime = 0
	self.flip = data.flip

	self.fixed_position.x = data.position_x
	self.fixed_position.y = data.position_y
	self.fixed_position.x += OFFSET_X * (-1 if flip else 1)
	self.fixed_position.y -= OFFSET_Y

	self.origin_x = self.fixed_position.x
	self.origin_y = self.fixed_position.y

	self.angle = data.angle

	$Sprite.rotation_degrees = 90 - rad2deg(angle / float(1 << 16))
	if self.flip:
		$Sprite.rotation_degrees = -$Sprite.rotation_degrees

	$Hitboxes.facing = -1 if self.flip else 1
	$Hitboxes.set_player(data.is_p2, true)
	$Hurtboxes.set_player(data.is_p2, true)

	add_to_group("network_sync")

	$AnimatedSprite.play("default")

	# _network_preprocess({})


func _network_preprocess(input: Dictionary) -> void:
	if hit:
		lifetime += 1
		return

	self.fixed_position.x = (
		origin_x
		+ SGFixed.cos(angle) * lifetime * KNIFE_SPEED * (-1 if flip else 1)
	)
	self.fixed_position.y = (origin_y - SGFixed.sin(angle) * lifetime * KNIFE_SPEED)

	lifetime += 1


# The game collides all hitboxes and hurtboxes!


func _network_postprocess(input: Dictionary) -> void:
	if fixed_position.y > 0:
		fixed_position.y = 0
		on_hit()

	if abs(fixed_position.x) > 1000 << 16:
		on_hit()

	if $Hurtboxes.hit_hitdata != null:
		on_hit()

	if lifetime > 300:
		SyncManager.despawn(self)


func on_hit():
	hit = true
	$Hitboxes/SGCollisionShape2D.disabled = true
	$Hurtboxes/SGCollisionShape2D.disabled = true
	$AnimatedSprite.play("explode")
	$Sprite.visible = false
	# SyncManager.despawn(self)


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
