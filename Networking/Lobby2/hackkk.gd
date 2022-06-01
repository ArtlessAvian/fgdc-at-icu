extends Control


func _process(delta):
	self.visible = get_parent().get_node("ConnectionScreen").visible
