extends SGFixedNode2D
class_name Fighter

# Pixels. since this doesn't need to be so fine grained.
export(int) var fighter_spacing = 50
export(int) var fighter_height = 50

# Subpixels per frame squared
export(int) var fighter_gravity = 32768

export(Resource) var moveset

# constants over the length of the game.
var controlled_by = "kb"
var is_dummy = false
var is_mash = false
export var is_p2 = false
export var opponent_path: NodePath = ""

# Subpixels per frame
var vel: SGFixedVector2 = SGFixedVector2.new()
var grounded = true

var health: int = 100
var state: Resource
var state_time = 0
var air_actions = 0
var state_dict: Dictionary = {}

var combo_count = 0
var hitstop = 0


func _ready():
	if self in get_tree().root.get_children():
		var cam = Camera2D.new()
		cam.current = true
		var node = Node.new()
		node.add_child(cam)
		add_child(node)

	if is_p2:
		$Hitboxes.toggle_player()
		$Hurtboxes.toggle_player()
		pass

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

	if hitstop > 0:
		return

	state_process(input)
	move()
	anim_process()


# Process happens. The game handles stuff dependent on both players.


func _network_postprocess(input: Dictionary) -> void:
	# technically, the hitstop will have decremented by now, but, whatever?
	if hitstop > 0:
		hitstop -= 1
		return

	hit_response(input)  # avoid p1 bias.


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
	state = new_state
	state_time = 0


func move():
	if not grounded:
		vel.y -= fighter_gravity

	self.fixed_position.x += vel.x
	self.fixed_position.y -= vel.y

	if self.fixed_position.y > 0:
		self.fixed_position.y = 0
		vel.y = 0
		grounded = true
		if state.can_land_cancel():
			change_to_state(moveset.walk)
			face_opponent()


func anim_process():
	var ani = state.animation(self)
	var assigned = $AnimationPlayer.assigned_animation
	if assigned != ani:
		if not $AnimationPlayer.has_animation(ani):
			printerr("No animation " + ani + "!")
		else:
			$AnimationPlayer.play("RESET")
			# print("RESET")
			$AnimationPlayer.advance(0)
			$AnimationPlayer.play(ani)
	$AnimationPlayer.advance(state_time - $AnimationPlayer.current_animation_position)
	pass


func hit_response(input: Dictionary):
	var can_block = false
	if sign(fixed_position.x - get_node(opponent_path).fixed_position.x) == input.stick_x:
		if state.can_block():
			can_block = true

	# Change hurtbox color if blocking or not blocking
	$Hurtboxes.modulate = Color.white
	if can_block:
		if input.stick_y < 0:
			$Hurtboxes.modulate = Color.blue
		else:
			$Hurtboxes.modulate = Color.cyan

	if not $Hurtboxes.hit_flag:
		return

	# So, I was hit.
	hitstop = 2

	if state in [moveset.hitstun]:
		combo_count += 1
	else:
		combo_count = 1

	if can_block:
		state_dict.hitstun = $Hurtboxes.hitstun
		change_to_state(moveset.blockstun)
	else:
		health = max(health - $Hurtboxes.damage, 0)
		print(self.name + " " + String(health))# TODO: Testing
		state_dict.hitstun = $Hurtboxes.hitstun
		change_to_state(moveset.hitstun)


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


func _get_local_input() -> Dictionary:
	if is_dummy:
		return NULL_INPUT

	if is_mash:
		var input = {
			stick_x = int(randi() % 3 - 1),
			just_stick_x = int(randi() % 3 - 1),
			stick_y = int(randi() % 3 - 1),
			just_stick_y = int(randi() % 3 - 1),
			light = randf() < 0.1,
			just_light = randf() < 0.1,
			heavy = randf() < 0.1,
			just_heavy = randf() < 0.1
		}
		return input

	var left = controlled_by + "_left"
	var right = controlled_by + "_right"
	var up = controlled_by + "_up"
	var down = controlled_by + "_down"
	var light = controlled_by + "_light"
	var heavy = controlled_by + "_heavy"

	var input = {
		stick_x = int(round(Input.get_axis(left, right))),
		just_stick_x = (
			int(Input.is_action_just_pressed(right))
			- int(Input.is_action_just_pressed(left))
		),
		stick_y = int(round(Input.get_axis(down, up))),
		just_stick_y = (
			int(Input.is_action_just_pressed(up))
			- int(Input.is_action_just_pressed(down))
		),
		light = Input.is_action_pressed(light),
		just_light = Input.is_action_just_pressed(light),
		heavy = Input.is_action_just_pressed(heavy),
		just_heavy = Input.is_action_just_pressed(heavy)
	}
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
		state_dict = state_dict.duplicate(),
		combo_count = combo_count,
		hitstop = hitstop,
		health = health
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
	state_dict = save.state_dict.duplicate(true)
	combo_count = save.combo_count
	hitstop = save.hitstop
	health = save.health

	$AnimationPlayer.play("RESET")
	$AnimationPlayer.advance(1000)
	$AnimationPlayer.play(state.animation(self))
	$AnimationPlayer.seek(state_time, true)
	$Hitboxes.sync_to_physics_engine()
	$Hurtboxes.sync_to_physics_engine()


func _on_Hitboxes_on_hit():
	pass
	# print("hehe")
