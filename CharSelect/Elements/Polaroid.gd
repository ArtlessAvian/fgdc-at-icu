extends Control
tool

export(Texture) var texture


func _ready():
	$Thing/PolaroidImage.texture = texture
