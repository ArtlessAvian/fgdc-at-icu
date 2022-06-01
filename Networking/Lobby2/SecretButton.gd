extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_SecretButton_button_up():
	get_tree().change_scene("res://Networking/Lobby/crude_connection.tscn")
