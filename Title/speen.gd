extends Sprite
tool

export var zrotation = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.x = cos(zrotation * 2 * PI)
	# Input.lmao
