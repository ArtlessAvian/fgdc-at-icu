extends SGFixedNode2D
class_name Fighter

const x_bound = 500 * 65565  # |x| can't go > x_bound
const y_bound = 0  # y can't go > 0

export(Resource) var moveset

export var is_p2 = false
export var opponent_path: NodePath = ""

var last_state = ""
var vel: SGFixedVector2 = SGFixedVector2.new()
var grounded: bool = true

var state


func _ready():
	if get_tree().root.get_child(0) == self:
		var cam = Camera2D.new()
		cam.current = true
		var node = Node.new()
		node.add_child(cam)
		add_child(node)
	pass

	state = moveset.walk


func _physics_process(_delta):
	state_process()
	# anim_process()
	move()
	# collide_hitboxes()


func state_process():
	if is_p2:
		return

	if state != null:
		state = state.transition(self, moveset)
		if state != null:
			state.run(self)
	else:
		print("remember to remove me!")


func move():
	if vel.y < 0:
		grounded = false

	if not grounded:
		vel.y += 30 * 65565 / 60

	self.fixed_position.x += vel.x
	self.fixed_position.y += vel.y

	if self.fixed_position.y >= 0:
		grounded = true
		self.fixed_position.y = 0
		state = moveset.walk

	if self.fixed_position.x > x_bound - 0 / 2:
		self.fixed_position.x = x_bound - 0 / 2
	if -self.fixed_position.x > x_bound - 0 / 2:
		self.fixed_position.x = -(x_bound - 0 / 2)
