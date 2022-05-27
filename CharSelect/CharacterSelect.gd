extends Control
tool

signal both_ready

export(String) var p1_controlled_by = "kb"
export(String) var p2_controlled_by = "kb"

export(int, 0, 4) var p1_index = 0
export(int, 0, 4) var p2_index = 1

export(bool) var p1_selected = false
export(bool) var p2_selected = false

export(Array, Resource) var descriptions


func _ready():
	p1_selected = false
	p2_selected = false
	pass  # Replace with function body.


func _process(delta):
	logic()
	visuals(delta)


func logic():
	if Engine.editor_hint:
		return

	if p1_controlled_by != "network":
		if not p1_selected:
			p1_index += int(Input.is_action_just_pressed(p1_controlled_by + "_down"))
			p1_index -= int(Input.is_action_just_pressed(p1_controlled_by + "_up"))
			p1_index = (p1_index + 5) % 5
		if Input.is_action_just_pressed(p1_controlled_by + "_light"):
			p1_selected = not p1_selected

	if p2_controlled_by != "network":
		if not p2_selected:
			p2_index += int(Input.is_action_just_pressed(p2_controlled_by + "_down"))
			p2_index -= int(Input.is_action_just_pressed(p2_controlled_by + "_up"))
			p2_index = (p2_index + 5) % 5
		if Input.is_action_just_pressed(p2_controlled_by + "_light"):
			p2_selected = not p2_selected

	if p2_controlled_by == "network":
		rpc("set_p1", p1_index, p1_selected)
	if p1_controlled_by == "network":
		rpc("set_p2", p2_index, p2_selected)

	if p1_selected and p2_selected:
		emit_signal("both_ready", p1_index, p2_index)


func visuals(delta):
	update_player(
		p1_index,
		p1_selected,
		$Player1/CenterLine/Name,
		$Player1/CenterLine/Portrait,
		$Player1/CenterLine/IndexCard/Title,
		$Player1/CenterLine/IndexCard/Text
	)
	update_player(
		p2_index,
		p2_selected,
		$Player2/CenterLine/Name,
		$Player2/CenterLine/Portrait,
		$Player2/CenterLine/IndexCard/Title,
		$Player2/CenterLine/IndexCard/Text
	)

	var p1_target = Vector2()
	p1_target.y = (p1_index + 1) * 720 / 6.0
	p1_target.x = 480 + (p1_index % 2) * 100
	$P1Cursor.position = $P1Cursor.position.linear_interpolate(p1_target, 0.2)

	var p2_target = Vector2()
	p2_target.y = (p2_index + 1) * 720 / 6.0
	p2_target.x = 800 - ((p2_index + 1) % 2) * 100
	$P2Cursor.position = $P2Cursor.position.linear_interpolate(p2_target, 0.2)

	$P1Cursor.rotation_degrees = 90 if not p1_selected else $P1Cursor.rotation_degrees + delta * 720
	$P2Cursor.rotation_degrees = 90 if not p2_selected else $P2Cursor.rotation_degrees + delta * 720


func update_player(index, selected, title, portrait, blurb, text):
	var desc = descriptions[index]
	portrait.texture = desc.portrait if not selected else desc.portrait_selected
	title.text = desc.name
	blurb.text = desc.blurb
	text.text = desc.description


func reset_char_select():
	p1_selected = false
	p2_selected = false


remote func set_p1(i, ye):
	p1_index = i
	p1_selected = ye


remote func set_p2(i, ye):
	p2_index = i
	p2_selected = ye
