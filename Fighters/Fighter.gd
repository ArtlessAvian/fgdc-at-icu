extends SGFixedNode2D
class_name Fighter

# Pixels. since this doesn't need to be so fine grained.
export(int) var fighter_spacing = 50
export(int) var fighter_height = 50

# Subpixels per frame squared
export(int) var fighter_gravity = 32768
export(int) var max_health = 100

export(Resource) var moveset

# constants over the length of the game.
var controlled_by = "kb"
export var is_p2 = false
export var opponent_path: NodePath = ""

# Subpixels per frame
var vel: SGFixedVector2 = SGFixedVector2.new()
var grounded = true

var health: int = 20
var state: Resource
var state_time = 0
var ani_start_time = 0
var air_actions = 0
var state_dict: Dictionary = {}
var invincible: bool = false

var combo_count = 0
var hitstop = 0


func _ready():
	self.fixed_position.x = (-200 << 16) * (-1 if is_p2 else 1)
	self.fixed_position.y = 0
	self.vel = SGFixedVector2.new()
	self.grounded = true
	self.health = self.max_health
	self.state_time = 0
	self.ani_start_time = 0
	self.air_actions = 0
	self.invincible = false

	$Hitboxes.set_player(is_p2)
	$Hurtboxes.set_player(is_p2)
	$Throwboxes.set_player(is_p2)

	$AnimationPlayer.playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	$AnimationPlayer.playback_speed = 1

	state = moveset.walk


# Stuff happening independently of the other player.
func _network_preprocess(input: Dictionary) -> void:
	if input.empty():
		# TODO: Better fix. Crashes on game start otherwise! :(
		for key in NULL_INPUT.keys():
			input[key] = NULL_INPUT[key]
		printerr("received empty input on tick ", SyncManager.current_tick)

	$InputHistory.new_input(input)

	if hitstop <= 0:
		state_process(input)
		move()
	anim_process()


# Process happens. The game handles stuff dependent on both players.


func _network_postprocess(input: Dictionary) -> void:
	# technically, the hitstop will have decremented by now, but, whatever?
	if hitstop > 0:
		hitstop -= 1
		return

	check_for_hit(input)  # avoid p1 bias.


func state_process(input: Dictionary):
	var new_state = state.transition(self, moveset, input)

	if new_state != null:
		change_to_state(new_state)
	else:
		state_time += 1

	# Hitbox enabledness is calculated every frame,
	# rather have it be stateful, and saved in the state for rollbacks!
	for hitbox in $Hitboxes.get_children():
		hitbox.disabled = true
	state.run(self, input)


func change_to_state(new_state):
	new_state.enter(self)
	state = new_state
	state_time = 0


func move():
	if not grounded:
		vel.y -= fighter_gravity

	self.fixed_position.x += vel.x
	self.fixed_position.y -= vel.y

	# i have made poor decisions making positive vel.y go "up" but -y in coordinates
	if self.fixed_position.y > 0 && self.vel.y <= 0:
		state.do_landing(self, moveset)
		var new_state = state.get_landing_transition(self, moveset)
		if new_state != null:
			change_to_state(new_state)
		# 	# print("landed")
		# 	self.fixed_position.y = 0
		# 	vel.y = 0
		# 	grounded = true
		# 	change_to_state(moveset.walk)
		# 	face_opponent()
		# else:
		# 	print("landed, no land cancel")
		# 	self.fixed_position.y = 0
		# 	vel.y = 0
		# 	grounded = true


func anim_process():
	var ani = state.animation(self)
	var assigned = $AnimationPlayer.assigned_animation
	if assigned != ani:
		if not $AnimationPlayer.has_animation(ani):
			printerr("No animation " + ani + "!")
			ani = "Walk"
		ani_start_time = state_time
		$AnimationPlayer.play("RESET")
		# print("RESET")
		$AnimationPlayer.advance(0)
		$AnimationPlayer.play(ani)
	$AnimationPlayer.advance(
		state_time - ani_start_time - $AnimationPlayer.current_animation_position
	)
	pass

	if $InputHistory.detect_charge_forward(self.fixed_scale_x < 0, 5, 30):
		self.modulate = Color.chartreuse
	elif $InputHistory.detect_charge_up(5, 30):
		self.modulate = Color.orange
	else:
		self.modulate = Color.white


func check_for_hit(input: Dictionary):
	# HACK: Prevent empty input
	if input.empty():
		for key in NULL_INPUT.keys():
			input[key] = NULL_INPUT[key]
		printerr("received empty input on tick ", SyncManager.current_tick)

	# Change hurtbox color if blocking or not blocking
	$Hurtboxes.modulate = Color.white
	if invincible:
		$Hurtboxes.modulate = Color(0.75, 0.50, 0.95)
	elif is_blocking(input):
		if input.stick_y < 0:
			$Hurtboxes.modulate = Color.blue
		else:
			$Hurtboxes.modulate = Color.cyan
	# End debuggy stuff.

	if $Hurtboxes.hit_hitdata != null and not invincible:
		# This fighter was hit.
		hit_response(input)
	elif $Hurtboxes.throw_throwdata != null and not invincible:
		throw_response(input)


func is_blocking(input: Dictionary):
	if sign(fixed_position.x - get_node(opponent_path).fixed_position.x) == input.stick_x:
		if state.can_block():
			return true
	return false


func hit_response(input: Dictionary):
	# Look at the hit.
	var diff = fixed_position.x - $Hurtboxes.hit_hitboxes.get_global_fixed_position().x
	if diff > 0 && fixed_scale.x > 0:
		fixed_scale.x *= -1
	if diff < 0 && fixed_scale.x < 0:
		fixed_scale.x *= -1

	# Check for block.
	var blocking = is_blocking(input)
	# Airblock / Chickenblock
	if not grounded and blocking:
		on_block()

	# int cast because godot is being uncooperative
	# Blocking a mid
	elif int($Hurtboxes.hit_hitdata.guard) == 0 and blocking:
		on_block()

	# Blocking a low
	elif int($Hurtboxes.hit_hitdata.guard) == 1 and blocking and input.stick_y < 0:
		on_block()

	# Blocking a low
	elif int($Hurtboxes.hit_hitdata.guard) == 2 and blocking and input.stick_y >= 0:
		on_block()

	# Block not correct direction or no block at all
	else:
		on_hit()


# Rename to "block_hit" when everyone's ready.
func on_block():
	$Hurtboxes.register_contact(true)

	hitstop = 2
	health = max(health - $Hurtboxes.hit_hitdata.chipdamage, 0)

	state_dict.blockstun = $Hurtboxes.hit_hitdata.blockstun
	vel.x = $Hurtboxes.hit_hitdata.x_vel << 16
	# no y component.

	# TODO: think about dying on hit
	if self.health <= 0:
		change_to_state(moveset.dead)
	else:
		change_to_state(moveset.blockstun)

	combo_count = 0


# Rename to "get_hit" when everyone's ready. ;_;
# Imagine being able to name things
func on_hit():
	$Hurtboxes.register_contact(false)

	hitstop = 2
	health = max(health - $Hurtboxes.hit_hitdata.damage, 0)

	if state in [moveset.hitstun]:
		combo_count += 1
	else:
		combo_count = 1

	state_dict.hitstun = $Hurtboxes.hit_hitdata.hitstun
	vel.x = ($Hurtboxes.hit_hitdata.x_vel << 16) * (-1 if fixed_scale.x > 0 else 1)
	vel.y = $Hurtboxes.hit_hitdata.y_vel << 16
	if vel.y > 0:
		grounded = false
		# gravity takes care of the rest!

	# print($Hurtboxes.hit_hitdata, SyncManager.current_tick)
	if self.health <= 0:
		change_to_state(moveset.dead)
	elif $Hurtboxes.hit_hitdata.knockdown:
		change_to_state(moveset.knockdown)
	else:
		change_to_state(moveset.hitstun)


func throw_response(input: Dictionary):
	var throwdata = $Hurtboxes.throw_throwdata

	if throwdata.is_air == grounded:
		print("doesn't match")
		return

	if state == moveset.throw:
		print("early throw tech")
		change_to_state(moveset.throw_tech)
		get_node(opponent_path).change_to_state(moveset.throw_tech)
		return
	if (
		not state in moveset.movement
		and not state in [moveset.walk, moveset.crouch, moveset.jump]
	):
		print("not neutral state")
		return

	state_dict["throwdata"] = throwdata
	change_to_state(moveset.get_thrown)
	var opponent = get_node(opponent_path)
	opponent.state_dict["my_throwdata"] = throwdata
	opponent.change_to_state(opponent.moveset.do_throw)


# Helper
func face_opponent():
	var diff = fixed_position.x - get_node(opponent_path).fixed_position.x
	if diff > 0 && fixed_scale.x > 0:
		fixed_scale.x *= -1
	if diff < 0 && fixed_scale.x < 0:
		fixed_scale.x *= -1


# Network bs
const NULL_INPUT = {
	stick_x = 0,
	just_stick_x = 0,
	stick_y = 0,
	just_stick_y = 0,
	light = false,
	just_light = false,
	heavy = false,
	just_heavy = false
}

var last_mash = NULL_INPUT


func _get_local_input() -> Dictionary:
	if controlled_by == "mash":
		if randf() < 0.9:
			return last_mash

		var input = {
			stick_x = int(randi() % 3 - 1),
			just_stick_x = 0,
			stick_y = int(randi() % 3 - 1),
			just_stick_y = 0,
			light = randf() < 0.3,
			just_light = false,
			heavy = randf() < 0.3,
			just_heavy = false
			# stick_x = 1,
			# just_stick_x = 0,
			# stick_y = -1,
			# just_stick_y = 0,
			# light = 0,
			# just_light = 0,
			# heavy = 0,
			# just_heavy = 0
		}
		last_mash = input
		return input

	var left = controlled_by + "_left"
	var right = controlled_by + "_right"
	var up = controlled_by + "_up"
	var down = controlled_by + "_down"
	var light = controlled_by + "_light"
	var heavy = controlled_by + "_heavy"

	var input = {
		stick_x = int(round(Input.get_axis(left, right))),
		just_stick_x = 0,
		stick_y = int(round(Input.get_axis(down, up))),
		just_stick_y = 0,
		light = Input.is_action_pressed(light),
		just_light = Input.is_action_just_pressed(light),
		heavy = Input.is_action_pressed(heavy),
		just_heavy = Input.is_action_just_pressed(heavy)
	}
	# print(input)
	return input


func _predict_remote_input(previous_input: Dictionary, ticks_since_real_input: int) -> Dictionary:
	if previous_input == null or previous_input.empty():
		# print("returning ", EMPTY_INPUT)
		return NULL_INPUT
	# print("returning ", previous_input)
	return previous_input


func _save_state() -> Dictionary:
	# saving state-machine-state in rollback-state should be fine, they're mostly constants.
	# var save =
	return {
		x = fixed_position.x,
		y = fixed_position.y,
		scalex = fixed_scale.x,
		vx = vel.x,
		vy = vel.y,
		grounded = grounded,
		air_actions = air_actions,
		state = state,
		state_time = state_time,
		ani_start_time = ani_start_time,
		state_dict = state_dict.duplicate(),
		combo_count = combo_count,
		hitstop = hitstop,
		health = health,
		invincible = invincible
	}
	# return save


func _load_state(save: Dictionary) -> void:
	fixed_position.x = save.x
	fixed_position.y = save.y
	fixed_scale.x = save.scalex
	vel.x = save.vx
	vel.y = save.vy
	grounded = save.grounded
	air_actions = save.air_actions
	state = save.state
	state_time = save.state_time
	ani_start_time = save.ani_start_time
	state_dict = save.state_dict.duplicate(true)
	combo_count = save.combo_count
	hitstop = save.hitstop
	health = save.health
	invincible = save.invincible

	$AnimationPlayer.play("RESET")
	$AnimationPlayer.advance(1000)
	$AnimationPlayer.play(state.animation(self))
	$AnimationPlayer.seek(state_time, true)
	$Hitboxes.sync_to_physics_engine()
	$Hurtboxes.sync_to_physics_engine()


func _on_Hitboxes_on_contact(blocked: bool):
	state_dict.last_attack_contact = $Hitboxes.attack_number
	if not blocked:
		state_dict.last_attack_hit = $Hitboxes.attack_number
