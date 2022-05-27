extends Node2D
tool

var alpha = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Card.rotation_degrees = 0


func _process(delta):
	var f = get_node("../..")
	if f.state == f.moveset.blockstun:
		alpha = 1
	elif f.state in [f.moveset.walk, f.moveset.crouch, f.moveset.jump]:
		alpha = max(0, alpha - delta * 5)
	else:
		alpha = 0

	if alpha > 0:
		$Card.rotation_degrees += delta * 540
	modulate = Color.transparent.linear_interpolate(Color.white, alpha)
