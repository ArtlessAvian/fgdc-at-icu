extends Node2D
tool

export(float) var flips = 0

var _base_scale: Vector2


func _ready():
	_base_scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = _base_scale * Vector2(cos(flips * PI), 1)
