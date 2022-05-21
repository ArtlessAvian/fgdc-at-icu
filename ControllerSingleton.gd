extends Node


func _ready():
	Input.connect("joy_connection_changed", self, "_on_hotplug")
	for i in range(len(Input.get_connected_joypads())):
		_on_hotplug(i, true)


func _on_hotplug(device: int, connected: bool):
	if not connected:
		return
	if InputMap.has_action("c" + str(device) + "_light"):
		return

	print("hotplugging controller ", device, ". its a ", Input.get_joy_name(device))

	for input in ["up", "down", "left", "right", "light", "heavy", "dash"]:
		InputMap.add_action("c" + str(device) + "_" + input)

		for ev in InputMap.get_action_list("c_" + input):
			var ev2 = ev.duplicate(true)
			ev2.device = device
			InputMap.action_add_event("c" + str(device) + "_" + input, ev2)
