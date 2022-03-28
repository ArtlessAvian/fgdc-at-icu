extends SGFixedNode2D
class_name Fighter

const fighter_spacing = 50 * 65565
const fighter_height = 50 * 65565

export(Resource) var moveset

# export var controlled_by = "ui"
var is_dummy = false
var is_mash = false
export var is_p2 = false
export var opponent_path: NodePath = ""

var vel: SGFixedVector2 = SGFixedVector2.new()
var grounded = false

var state: Resource
var state_time = 0
var air_actions
var state_dict: Dictionary = {}


func _ready():
	if self in get_tree().root.get_children():
		var cam = Camera2D.new()
		cam.current = true
		var node = Node.new()
		node.add_child(cam)
		add_child(node)

	if is_p2:
		# $Hitboxes.collision_mask ^= 0b11
		# $Hurtboxes.collision_layer ^= 0b11
		pass

	state = moveset.walk


# # Stuff happening independently of the other player.
func _network_preprocess(input: Dictionary) -> void:
	if input.empty():
		# TODO: Better fix. Crashes on game start otherwise! :(
		input = NULL_INPUT
		printerr("received empty input on tick ", SyncManager.current_tick)

	state_process(input)
	move()
	anim_process()


# # Process happens. The game handles stuff dependent on both players.


func _network_postprocess(input: Dictionary) -> void:
	hit_response()  # avoid p1 bias.


func state_process(input: Dictionary):
	if state != null:
		var new_state = state.transition(self, moveset, input)
		if new_state != null:
			state = new_state
			state_time = 0
		else:
			state_time += 1
		if state != null:
			state.run(self, input)
	else:
		print("remember to remove me!")


func move():
	if not grounded:
		vel.y -= 30 * 65536 / 60

	self.fixed_position.x += vel.x
	self.fixed_position.y -= vel.y

	if self.fixed_position.y > 0:
		self.fixed_position.y = 0
		vel.y = 0
		grounded = true
		if state.land_cancels:
			state = moveset.walk
			state_time = 0


func anim_process():
	var ani = state.animation(self)
	var assigned = $AnimationPlayer.assigned_animation
	if assigned != ani:
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.advance(0)
		$AnimationPlayer.play(ani)
	$AnimationPlayer.seek(state_time, true)
	pass


func hit_response():
	if $Hurtboxes.hit_flag:
		# $Hurtboxes.hit_flag = false

		state_dict.hitstun = $Hurtboxes.hitstun

		state_time = 0
		state = moveset.hitstun


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
			light = false,
			just_light = false,
			heavy = false,
			just_heavy = false
		}
		return input

	var input = {
		stick_x = int(round(Input.get_axis("ui_left", "ui_right"))),
		just_stick_x = (
			int(Input.is_action_just_pressed("ui_right"))
			- int(Input.is_action_just_pressed("ui_left"))
		),
		stick_y = int(round(Input.get_axis("ui_down", "ui_up"))),
		just_stick_y = (
			int(Input.is_action_just_pressed("ui_up"))
			- int(Input.is_action_just_pressed("ui_down"))
		),
		light = Input.is_action_pressed("ui_select"),
		just_light = Input.is_action_just_pressed("ui_select"),
		heavy = false,
		just_heavy = false
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
	}


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
