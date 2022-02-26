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

	$Hitboxes/SGCollisionShape2D.disabled = not input.just_light

	anim_process()
	collide_hitboxes()


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

	# var other = get_node(opponent_path)
	# var distance = abs(self.fixed_position.x, opponent_path.fixed_position.x):
	# i must be player 1


func anim_process():
	$Hitboxes.sync_to_physics_engine()
	$Hurtboxes.sync_to_physics_engine()


func collide_hitboxes():
	var hitboxes: SGArea2D = $Hitboxes
	for hurtboxes in hitboxes.get_overlapping_areas():
		if hurtboxes == $Hurtboxes:
			continue
		if hurtboxes is HurtboxBuffer:
			hurtboxes.hit_flag = true
			print("i hit!")


func hit_response():
	if $Hurtboxes.hit_flag:
		$Hurtboxes.hit_flag = false
		print("owch")


# Network bs
func _get_local_input():
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
		state = state
	}


func _load_state(state: Dictionary) -> void:
	fixed_position.x = state.x
	fixed_position.y = state.y
	vel.x = state.vx
	vel.y = state.vy
	apply_gravity = state.apply_gravity
	air_actions = state.air_actions
	self.state = state.state
