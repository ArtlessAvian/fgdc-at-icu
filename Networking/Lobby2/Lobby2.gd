# Lifted from the netcode tutorial
extends Node

var ai_by_index = ["mash", "block", "punish", "upback"]

# var hardcoded_character_names = ["Max (WIP)", "Lippo (WIP)", "Boba (WIPPPP)"]  #, "Batperson (Sample, No Balance)"

var hardcoded_characters = [
	"res://Characters/Max/Max.tscn",
	"res://Characters/Lippo/Lippo.tscn",
	"res://Characters/Boba/Boba.tscn",
	"res://Characters/Max/Max.tscn",
]

# var controllers_by_index = ["kb", "c0", "c1", "mash", "block", "punish", "upback"]
# var controllers_by_name = [
# 	"Keyboard (Arrows, ASD)",
# 	"Controller 1 (Facebuttons, R1)",
# 	"Controller 2 (Facebuttons, R1)",
# 	"Mash (AI)",
# 	"Block (AI)",
# 	"Block and Punish (AI)",
# 	# "Block after first hit (AI)",
# 	"Advancing Chickenblock (AI)"
# ]


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	SyncManager.connect("sync_started", self, "_on_SyncManager_sync_started")
	SyncManager.connect("sync_stopped", self, "_on_SyncManager_sync_stopped")
	SyncManager.connect("sync_lost", self, "_on_SyncManager_sync_lost")
	SyncManager.connect("sync_regained", self, "_on_SyncManager_sync_regained")
	SyncManager.connect("sync_error", self, "_on_SyncManager_sync_error")

	find_node("LocalButton").connect("button_down", self, "_on_LocalButton")
	find_node("HostButton").connect("button_down", self, "_on_HostButton")
	find_node("ClientButton").connect("button_down", self, "_on_ClientButton")

	$CanvasLayer/CharacterSelect.connect(
		"both_ready", self, "_on_CharactersSelected", [], CONNECT_ONESHOT
	)

	$CanvasLayer/CharacterSelect.set_process(false)


func _on_HostButton():
	SyncManager.network_adaptor = load("res://addons/godot-rollback-netcode/RPCNetworkAdaptor.gd").new()

	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(find_node("Port").text), 1)
	get_tree().network_peer = peer

	find_node("HostButton").disabled = true
	find_node("ClientButton").disabled = true
	find_node("LocalButton").disabled = true


func _on_ClientButton():
	SyncManager.network_adaptor = load("res://addons/godot-rollback-netcode/RPCNetworkAdaptor.gd").new()

	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(find_node("Host").text, int(find_node("Port").text))
	get_tree().network_peer = peer

	find_node("HostButton").disabled = true
	find_node("ClientButton").disabled = true
	find_node("LocalButton").disabled = true


func _on_LocalButton():
	SyncManager.network_adaptor = load("res://addons/godot-rollback-netcode/DummyNetworkAdaptor.gd").new()

	find_node("HostButton").disabled = true
	find_node("ClientButton").disabled = true
	find_node("LocalButton").disabled = true

	var dropdown: OptionButton = find_node("LocalInput1")
	var controller = dropdown_index_to_action(dropdown.get_item_id(dropdown.selected))
	$CanvasLayer/CharacterSelect.p1_controlled_by = controller

	dropdown = find_node("LocalInput2")
	controller = dropdown_index_to_action(dropdown.get_item_id(dropdown.selected))
	$CanvasLayer/CharacterSelect.p2_controlled_by = controller

	$CanvasLayer/ConnectionScreen.visible = false
	$CanvasLayer/CharacterSelect.set_process(true)


func _on_network_peer_connected(peer_id: int):
	print("success!")
	SyncManager.add_peer(peer_id)
	if peer_id != 1:
		# i am the host.
		self.rpc("_host_decides_side", peer_id, true)  # bool(randi() % 2))


var p1_peer = 1
var p2_peer = 1


remotesync func _host_decides_side(client_id, host_is_p1):
	var dropdown: OptionButton = find_node("OnlineInput")
	var controller = dropdown_index_to_action(dropdown.get_item_id(dropdown.selected))

	if host_is_p1:
		p1_peer = 1
		p2_peer = client_id
	else:
		p1_peer = client_id
		p2_peer = 1

	var i_am_host = get_tree().get_network_unique_id() == 1

	if host_is_p1 == i_am_host:
		$CanvasLayer/CharacterSelect.p1_controlled_by = controller
		$CanvasLayer/CharacterSelect.p2_controlled_by = "network"
	else:
		$CanvasLayer/CharacterSelect.p1_controlled_by = "network"
		$CanvasLayer/CharacterSelect.p2_controlled_by = controller
	print(p1_peer, " ", p2_peer)

	$CanvasLayer/ConnectionScreen.visible = false
	$CanvasLayer/CharacterSelect.set_process(true)


func _on_CharactersSelected(p1, p2):
	print("Characters selected called")
	$CanvasLayer/CharacterSelect.set_process(false)
	if get_tree().network_peer == null or get_tree().get_network_unique_id() == 1:
		_host_decides_random(p1, p2)


master func _host_decides_random(p1, p2):
	if p1 == 4:
		p1 = randi() % 4
	if p2 == 4:
		p2 = randi() % 4
	if get_tree().network_peer != null:
		rpc("setup_characters", p1, p2)
	else:
		setup_characters(p1, p2)


remotesync func setup_characters(p1, p2):
	$Match.set_character(load(hardcoded_characters[p1]), false, p1_peer)
	$Match.set_character(load(hardcoded_characters[p2]), true, p2_peer)

	if p1_peer == 1 and p2_peer == 1:
		# set it normally
		var dropdown: OptionButton = find_node("LocalInput1")
		var controller = dropdown_index_to_action(dropdown.get_item_id(dropdown.selected))
		$Match/Game/Fighter1.controlled_by = controller

		dropdown = find_node("LocalInput2")
		controller = dropdown_index_to_action(dropdown.get_item_id(dropdown.selected))
		$Match/Game/Fighter2.controlled_by = controller
	else:
		# hack. set both to the same.
		# one is ignored anyways.
		var dropdown: OptionButton = find_node("OnlineInput")
		var controller = dropdown_index_to_action(dropdown.get_item_id(dropdown.selected))
		$Match/Game/Fighter1.controlled_by = controller
		$Match/Game/Fighter2.controlled_by = controller

	if get_tree().network_peer != null:
		rpc("im_ready")
	else:
		start_the_game()


var aaa = 0


remotesync func im_ready():
	aaa += 1
	if aaa == 2:
		start_the_game()


func start_the_game():
	$CanvasLayer/CharacterSelect.visible = false
	if get_tree().network_peer == null or get_tree().get_network_unique_id() == 1:
		yield(get_tree().create_timer(0.1), "timeout")
		SyncManager.start()


func reset_the_game():
	SyncManager.stop()
	self._ready()
	$CanvasLayer/CharacterSelect.visible = true
	$CanvasLayer/CharacterSelect.reset_char_select()
	$CanvasLayer/CharacterSelect.set_process(true)


# HELPER
func dropdown_index_to_action(index):
	if index == 4096:
		return "kb"
	if index < 100:
		# return "c" + str(index)
		return "c"
	return ai_by_index[index - 100]


# 	$CanvasLayer/MarginContainer.visible = false
# 	$CanvasLayer/ColorRect.visible = false

# 	$Match/Game/Fighter1.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/LocalInput1.selected]
# 	$Match/Game/Fighter2.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/LocalInput2.selected]

# 	var replay_dict = {}
# 	replay_dict["p1"] = hardcoded_characters[$CanvasLayer/MarginContainer/GridContainer/LocalCharacter.selected]
# 	replay_dict["p2"] = hardcoded_characters[$CanvasLayer/MarginContainer/GridContainer/LocalCharacter2.selected]

# 	# $Match.set_character(load("res://Example/Example.tscn"), true)
# 	if not SyncReplay.active:
# 		var directory = Directory.new()
# 		if not directory.open("user://replays/") == OK:
# 			print("made directory")
# 			directory.make_dir("user://replays/")
# 		SyncManager.start_logging(
# 			"user://replays/" + str(OS.get_unix_time()) + "-local.log", replay_dict
# 		)

# 	SyncManager.start()

# # NETWORKING====================================================

# 	var game_instance = find_node("Game", true, false)
# 	var replay_dict = {}

# 	self.rpc(
# 		"set_character_network",
# 		hardcoded_characters[$CanvasLayer/MarginContainer/GridContainer/OnlineCharacter.selected],
# 		replay_dict
# 	)

# 	if not SyncReplay.active:
# 		var directory = Directory.new()
# 		if not directory.open("user://replays/") == OK:
# 			print("made directory")
# 			directory.make_dir("user://replays/")
# 		SyncManager.start_logging(
# 			"user://replays/" + str(OS.get_unix_time()) + "-online.log", replay_dict
# 		)

# 	# game_instance.get_node("Fighter1").set_network_master(1)
# 	# if get_tree().is_network_server():
# 	# 	game_instance.get_node("Fighter2").set_network_master(peer_id)
# 	# else:
# 	# 	game_instance.get_node("Fighter2").set_network_master(get_tree().get_network_unique_id())

# 	# Tried reordering everything below here. it worked before, but it doesn't seem to work anymore.
# 	$CanvasLayer/MarginContainer.visible = false
# 	$CanvasLayer/ColorRect.visible = false

# 	# Get away with setting both to the same, since one is ignored
# 	$Match/Game/Fighter1.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/OnlineInput.selected]
# 	$Match/Game/Fighter2.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/OnlineInput.selected]

# 	if get_tree().is_network_server():
# 		yield(get_tree().create_timer(0.2), "timeout")
# 		SyncManager.start()

# remotesync func set_character_network(scene_path: String, replay_dict: Dictionary):
# 	var peer_id = get_tree().get_rpc_sender_id()
# 	$Match.set_character(load(scene_path), peer_id != 1, peer_id)
# 	replay_dict["p1" if peer_id == 1 else "p2"] = scene_path
# 	print(scene_path, peer_id)


func _on_network_peer_disconnected(peer_id: int):
	SyncManager.remove_peer(peer_id)


func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)


# # Rollback Library ===========================================================


func _on_SyncManager_sync_started() -> void:
	pass


func _on_SyncManager_sync_stopped() -> void:
	if not SyncReplay.active:
		SyncManager.stop_logging()
	print("dumpy")


func _on_SyncManager_sync_lost() -> void:
	$CanvasLayer/SyncLost.visible = true


func _on_SyncManager_sync_regained() -> void:
	$CanvasLayer/SyncLost.visible = false


func _on_SyncManager_sync_error(msg: String) -> void:
	var peer = get_tree().network_peer
	if peer:
		peer.close_connection()
	SyncManager.clear_peers()


# func _on_LocalCharacter_item_selected(index: int, is_p2: bool):
# 	$Match.set_character(load(hardcoded_characters[index]), is_p2)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if not SyncReplay.active:
			SyncManager.stop_logging()

# func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
# 	$Match.set_character(load(match_info["p1"]), false)
# 	$Match.set_character(load(match_info["p2"]), true)
# 	$CanvasLayer/MarginContainer.visible = false
# 	$CanvasLayer/ColorRect.visible = false
