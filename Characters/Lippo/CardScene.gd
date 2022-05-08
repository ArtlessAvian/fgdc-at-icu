extends SGFixedNode2D

const OFFSET_X = 90 * 65536
const OFFSET_Y = 0 * 65536
const TARGET_OFFSET_Y = 100 * 65536
export(int) var MISSILE_HEIGHT = 700 << 16  # the height of the missiles in subpixels
export(int) var MISSILE_SPEED = 25  # up, and down
export(int) var MISSILE_TIME = 120  # when the missiles begin falling

var flip = false
var lifetime = 0
var origin_x = 0
var origin_y = 0
var target_path = ""
var owner_path = ""
var my_angle = -8765309
var hit = false


func _network_spawn(data: Dictionary):
	self.flip = data.flip
	self.lifetime = 0

	self.target_path = data.target_path
	self.owner_path = data.owner_path

	self.fixed_position.x = data.position_x
	self.fixed_position.y = data.position_y
	self.fixed_position.x += OFFSET_X * (-1 if flip else 1)
	self.fixed_position.y -= OFFSET_Y

	self.origin_x = self.fixed_position.x
	self.origin_y = self.fixed_position.y

	$Hitboxes.set_player(data.is_p2)

	add_to_group("network_sync")

	$AnimatedSprite.play("default")


func _network_preprocess(input: Dictionary) -> void:
	if hit:
		lifetime += 1
		return

	if lifetime < MISSILE_TIME:
		self.fixed_position.y = self.origin_y - lifetime * MISSILE_SPEED << 16
	elif lifetime == MISSILE_TIME:
		var dy = get_node(target_path).fixed_position.y + TARGET_OFFSET_Y - MISSILE_HEIGHT
		var dx = get_node(target_path).fixed_position.x - self.origin_x
		self.my_angle = SGFixed.atan2(dy, dx)
	elif lifetime > MISSILE_TIME:
		self.fixed_position.x = (
			origin_x
			+ SGFixed.cos(self.my_angle) * (lifetime - MISSILE_TIME) * MISSILE_SPEED
		)
		self.fixed_position.y = -(
			MISSILE_HEIGHT
			+ SGFixed.sin(self.my_angle) * (lifetime - MISSILE_TIME) * MISSILE_SPEED
		)
		# Me. Gets mad when someone bullshits the trig
		# Also me.
		$Sprite.rotation_degrees = 90 - rad2deg(self.my_angle / float(1 << 16))
		print($Sprite.rotation_degrees)

	lifetime += 1


# The game collides all hitboxes and hurtboxes!


func _network_postprocess(input: Dictionary) -> void:
	if fixed_position.y > 0:
		fixed_position.y = 0
		on_hit()

	if lifetime > 300:
		SyncManager.despawn(self)


func on_hit():
	hit = true
	$Hitboxes/SGCollisionShape2D.disabled = true
	$AnimatedSprite.play("explode")
	$Sprite.visible = false
	# SyncManager.despawn(self)


func _save_state() -> Dictionary:
	return {
		x = fixed_position.x,
		y = fixed_position.y,
		lifetime = lifetime,
		hit = hit,
		origin_x = origin_x,
		origin_y = origin_y,
		my_angle = my_angle
	}


func _load_state(save: Dictionary) -> void:
	fixed_position.x = save.x
	fixed_position.y = save.y
	lifetime = save.lifetime
	hit = save.hit
	origin_x = save.origin_x
	origin_y = save.origin_y
	my_angle = save.my_angle

	$Hitboxes/SGCollisionShape2D.disabled = hit
	$Hitboxes.sync_to_physics_engine()


func _on_Hitboxes_on_contact(blocked: bool, hitstop):
	on_hit()

	var f = get_node(self.owner_path)
	f.state_dict.last_attack_contact = f.get_node("Hitboxes").attack_number
	if not blocked:
		f.state_dict.last_attack_hit = f.get_node("Hitboxes").attack_number
