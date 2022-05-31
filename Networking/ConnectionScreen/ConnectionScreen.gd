extends CenterContainer
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ai_by_name = [
	"Mash (AI)",
	"Block (AI)",
	"Block and Punish (AI)",
	# "Block after first hit (AI)",
	"Advancing Chickenblock (AI)"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.connect("joy_connection_changed", self, "_on_hotplug")
	_on_hotplug(0, true)


func _on_hotplug(device: int, connected: bool):
	refresh_inputs($a/b/c/LocalInput1)
	refresh_inputs($a/b/d/LocalInput2)
	refresh_inputs($a/e/i/j/OnlineInput)

	var aaa: OptionButton = $a/b/d/LocalInput2
	aaa.select(aaa.get_item_index(100))


func refresh_inputs(dropdown: OptionButton, ai_allowed: bool = true):
	dropdown.clear()
	dropdown.add_item("Keyboard (Arrows, ASD)", 4096)
	for i in Input.get_connected_joypads():
		dropdown.add_item(str(i + 1) + ": " + Input.get_joy_name(i), i)

	if ai_allowed:
		for i in range(len(ai_by_name)):
			dropdown.add_item(ai_by_name[i], i + 100)
