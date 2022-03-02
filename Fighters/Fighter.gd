extends SGFixedNode2D
class_name Fighter

const x_bound = 500 * 65565  # |x| can't go > x_bound
const y_bound = 0  # y can't go > 0

export(Resource) var moveset

export var controlled_by = "ui"
export var is_p2 = false
export var opponent_path: NodePath = ""

var vel: SGFixedVector2 = SGFixedVector2.new()
var apply_gravity = false

var state
var state_time = 0
var air_actions
var state_dict : Dictionary = {}


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


func _network_process(input: Dictionary) -> void:
	state_process(input)
	move()
	max_distance()

	anim_process()
	$Hurtboxes.collide_hitboxes()


func _network_postprocess(input: Dictionary) -> void:
	hit_response()


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
	if apply_gravity:
		vel.y -= 30 * 65536 / 60

	self.fixed_position.x += vel.x
	self.fixed_position.y -= vel.y

	if self.fixed_position.y > 0:
		self.fixed_position.y = 0
		vel.y = 0
		state = moveset.walk
		state_time = 0
		apply_gravity = false

	if self.fixed_position.x > x_bound - 0 / 2:
		self.fixed_position.x = x_bound - 0 / 2
	if -self.fixed_position.x > x_bound - 0 / 2:
		self.fixed_position.x = -(x_bound - 0 / 2)


func max_distance():
	if is_p2:
		return
	# i must be player 1

	# var other = get_node(opponent_path)
	# var distance = abs(self.fixed_position.x, opponent_path.fixed_position.x):



func anim_process():
	var ani = state.animation(self)
	if $AnimationPlayer.current_animation != ani:
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.seek(0, true)
		$AnimationPlayer.play(ani)

	$Hitboxes.sync_to_physics_engine()
	$Hurtboxes.sync_to_physics_engine()


func hit_response():
	if $Hurtboxes.hit_flag:
		$Hurtboxes.hit_flag = false
		
		state_dict.hitstun = $Hurtboxes.hitstun
		
		state_time = 0
		state = moveset.hitstun

export (bool) var is_dummy = false

# Network bs
func _get_local_input():
	if is_dummy:
		return {
			stick_x = 0,
			just_stick_x = 0,
			stick_y = 0,
			just_stick_y = 0,
			light = false,
			just_light = false,
			heavy = false,
			just_heavy = false	
		}

	return {
		stick_x = Input.get_axis("ui_left", "ui_right"),
		just_stick_x = (
			int(Input.is_action_just_pressed("ui_right"))
			- int(Input.is_action_just_pressed("ui_left"))
		),
		stick_y = Input.get_axis("ui_down", "ui_up"),
		just_stick_y = (
			int(Input.is_action_just_pressed("ui_up"))
			- int(Input.is_action_just_pressed("ui_down"))
		),
		light = Input.is_action_pressed("ui_select"),
		just_light = Input.is_action_just_pressed("ui_select"),
		heavy = false,
		just_heavy = false
	}


func _predict_remote_input(previous_input: Dictionary, ticks_since_real_input: int) -> Dictionary:
	return previous_input


func _save_state() -> Dictionary:
	# saving state-machine-state in rollback-state should be fine, they're mostly constants.
	return {
		x = fixed_position.x,
		y = fixed_position.y,
		vx = vel.x,
		vy = vel.y,
		apply_gravity = apply_gravity,
		air_actions = air_actions,
		state = state,
		state_time = state_time,
		state_dict = state_dict.duplicate(),
	}


func _load_state(save: Dictionary) -> void:
	fixed_position.x = save.x
	fixed_position.y = save.y
	vel.x = save.vx
	vel.y = save.vy
	apply_gravity = save.apply_gravity
	air_actions = save.air_actions
	state = save.state
	state_time = save.state_time
	state_dict = save.state_dict
