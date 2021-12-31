extends Sprite3D

const x_bound = 10; # |x| can't go > x_bound
const y_bound = 0; # y can't go < 0

export var is_p2 = false

var vel : Vector2 = Vector2()
var grounded : bool = true

func _ready():
	pass

func _physics_process(delta):
	get_input()
	move(delta)

func get_input():
	if is_p2:
		return

	if grounded:
		vel.x = 0;
		if Input.is_action_pressed("ui_left"):
			vel.x -= 5
		if Input.is_action_pressed("ui_right"):
			vel.x += 5
		if Input.is_action_pressed("ui_up"):
			grounded = false
			vel.y += 10

func move(delta):
	if not grounded:
		vel.y -= 20 * delta

	self.translation += Vector3(vel.x, vel.y, 0) * delta

	if self.translation.y < 0:
		grounded = true
		self.translation.y = 0

	if self.translation.x > x_bound - $Collision.scale.x/2:
		self.translation.x = x_bound - $Collision.scale.x/2
	if -self.translation.x > x_bound - $Collision.scale.x/2:
		self.translation.x = -(x_bound - $Collision.scale.x/2)
