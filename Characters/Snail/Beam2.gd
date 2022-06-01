extends Node2D
tool

export(float) var scaleeee = 1
export(float, 0, 1) var thinness = 0.25


func _process(delta):
	scale = Vector2(1, thinness) * scaleeee
