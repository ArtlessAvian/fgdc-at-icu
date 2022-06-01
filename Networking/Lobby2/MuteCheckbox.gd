extends CheckBox

export(String) var busssss


func _on_toggled(button_pressed):
	var bus_index = AudioServer.get_bus_index(busssss)
	AudioServer.set_bus_mute(bus_index, button_pressed)
