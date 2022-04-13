extends Node2D
tool

export(float) var flips = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = Vector2(cos(flips * PI), 1)
