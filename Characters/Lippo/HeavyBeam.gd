extends Sprite


func _ready():
	pass  # Replace with function body.


func _process(delta):
	var f = get_node("../..")
	if f.state == f.moveset.heavy:
		# self.visible = not f.get_node("Hitboxes/SGCollisionShape2D").disabled
		self.visible = 20 <= f.state_time and f.state_time < 63
		self.position.y = -(f.state_time * 47 % 150)
	else:
		self.visible = false
