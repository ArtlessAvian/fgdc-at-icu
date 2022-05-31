extends Node2D
tool

var flip = false
var lifetime = 0


# func initializeee(data: Dictionary):
# 	self.global_position.x = data.position_x
# 	self.global_position.y = data.position_y
func _ready():
	self.scale = Vector2.ZERO
	self.rotation_degrees = (randf() - 0.5) * 2 * 45
	lifetime = 0


func _physics_process(delta):  #(input: Dictionary) -> void:
	lifetime += 1

	self.scale = (Vector2.ONE / 2000.0) * (1000 * sqrt(lifetime / 10.0))
	self.modulate.a = clamp((10 - lifetime) / 10.0, 0, 1)

	if lifetime > 10:
		if Engine.editor_hint:
			_ready()
		else:
			self.queue_free()
