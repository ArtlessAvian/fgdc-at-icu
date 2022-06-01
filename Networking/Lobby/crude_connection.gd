# Lifted from the netcode tutorial
extends Node

# Lifted from the netcode tutorial
onready var host_field = $CanvasLayer/MarginContainer/GridContainer/HostField
onready var port_field = $CanvasLayer/MarginContainer/GridContainer/PortField

var hardcoded_character_names = ["Max", "Lippo (WIP)", "Boba (WIPPPP)", "Snail (don't play)"]  #, "Batperson (Sample, No Balance)"

var hardcoded_characters = [
	"res://Characters/Max/Max.tscn",
	"res://Characters/Lippo/Lippo.tscn",
	"res://Characters/Boba/Boba.tscn",
	"res://Characters/Snail/Snail.tscn",
]
var controllers_by_index = ["kb", "c0", "c1", "mash", "block", "punish", "upback"]
var controllers_by_name = [
	"Keyboard (Arrows, ASD)",
	"Controller 1 (Facebuttons, R1)",
	"Controller 2 (Facebuttons, R1)",
	"Mash (AI)",
	"Block (AI)",
	"Block and Punish (AI)",
	# "Block after first hit (AI)",
	"Advancing Chickenblock (AI)"
]


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	SyncManager.connect("sync_started", self, "_on_SyncManager_sync_started")
	SyncManager.connect("sync_stopped", self, "_on_SyncManager_sync_stopped")
	SyncManager.connect("sync_lost", self, "_on_SyncManager_sync_lost")
	SyncManager.connect("sync_regained", self, "_on_SyncManager_sync_regained")
	SyncManager.connect("sync_error", self, "_on_SyncManager_sync_error")

	setup_dropdowns($CanvasLayer/MarginContainer/GridContainer/OnlineCharacter)
	setup_dropdowns($CanvasLayer/MarginContainer/GridContainer/LocalCharacter)
	setup_dropdowns($CanvasLayer/MarginContainer/GridContainer/LocalCharacter2)

	setup_input_dropdown($CanvasLayer/MarginContainer/GridContainer/LocalInput1)
	setup_input_dropdown($CanvasLayer/MarginContainer/GridContainer/LocalInput2)
	$CanvasLayer/MarginContainer/GridContainer/LocalInput2.selected = 1
	setup_input_dropdown($CanvasLayer/MarginContainer/GridContainer/OnlineInput)

	_on_LocalCharacter_item_selected(0, true)
	_on_LocalCharacter_item_selected(0, false)


func setup_dropdowns(dropdown: OptionButton):
	dropdown.clear()
	for i in range(len(hardcoded_character_names)):
		dropdown.add_item(hardcoded_character_names[i], i)


func setup_input_dropdown(dropdown: OptionButton):
	dropdown.clear()
	for i in range(len(controllers_by_index)):
		dropdown.add_item(controllers_by_name[i], i)


func _on_Server_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(port_field.text), 1)
	get_tree().network_peer = peer


func _on_Client_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(host_field.text, int(port_field.text))
	get_tree().network_peer = peer


func _on_Local_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(31415, 1)
	get_tree().network_peer = peer

	$CanvasLayer/MarginContainer.visible = false
	$CanvasLayer/ColorRect.visible = false

	$Match/Game/Fighter1.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/LocalInput1.selected]
	$Match/Game/Fighter2.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/LocalInput2.selected]

	var replay_dict = {}
	replay_dict["p1"] = hardcoded_characters[$CanvasLayer/MarginContainer/GridContainer/LocalCharacter.selected]
	replay_dict["p2"] = hardcoded_characters[$CanvasLayer/MarginContainer/GridContainer/LocalCharacter2.selected]

	# $Match.set_character(load("res://Example/Example.tscn"), true)
	if not SyncReplay.active:
		var directory = Directory.new()
		if not directory.open("user://replays/") == OK:
			print("made directory")
			directory.make_dir("user://replays/")
		SyncManager.start_logging(
			"user://replays/" + str(OS.get_unix_time()) + "-local.log", replay_dict
		)

	SyncManager.start()
	$Match/Game/UILayer/TestIntro.match_start()


# NETWORKING====================================================


func _on_network_peer_connected(peer_id: int):
	print("success!")
	SyncManager.add_peer(peer_id)

	var game_instance = find_node("Game", true, false)
	var replay_dict = {}

	self.rpc(
		"set_character_network",
		hardcoded_characters[$CanvasLayer/MarginContainer/GridContainer/OnlineCharacter.selected],
		replay_dict
	)

	if not SyncReplay.active:
		var directory = Directory.new()
		if not directory.open("user://replays/") == OK:
			print("made directory")
			directory.make_dir("user://replays/")
		SyncManager.start_logging(
			"user://replays/" + str(OS.get_unix_time()) + "-online.log", replay_dict
		)

	# game_instance.get_node("Fighter1").set_network_master(1)
	# if get_tree().is_network_server():
	# 	game_instance.get_node("Fighter2").set_network_master(peer_id)
	# else:
	# 	game_instance.get_node("Fighter2").set_network_master(get_tree().get_network_unique_id())

	# Tried reordering everything below here. it worked before, but it doesn't seem to work anymore.
	$CanvasLayer/MarginContainer.visible = false
	$CanvasLayer/ColorRect.visible = false

	# Get away with setting both to the same, since one is ignored
	$Match/Game/Fighter1.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/OnlineInput.selected]
	$Match/Game/Fighter2.controlled_by = controllers_by_index[$CanvasLayer/MarginContainer/GridContainer/OnlineInput.selected]

	if get_tree().is_network_server():
		yield(get_tree().create_timer(0.2), "timeout")
		SyncManager.start()
		$Match/Game/UILayer/TestIntro.match_start()


remotesync func set_character_network(scene_path: String, replay_dict: Dictionary):
	var peer_id = get_tree().get_rpc_sender_id()
	$Match.set_character(load(scene_path), peer_id != 1, peer_id)
	replay_dict["p1" if peer_id == 1 else "p2"] = scene_path


func _on_network_peer_disconnected(peer_id: int):
	SyncManager.remove_peer(peer_id)


func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)


# Rollback Library ===========================================================


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


func _on_LocalCharacter_item_selected(index: int, is_p2: bool):
	$Match.set_character(load(hardcoded_characters[index]), is_p2)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if not SyncReplay.active:
			SyncManager.stop_logging()


func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
	$Match.set_character(load(match_info["p1"]), false)
	$Match.set_character(load(match_info["p2"]), true)
	$CanvasLayer/MarginContainer.visible = false
	$CanvasLayer/ColorRect.visible = false


func _on_newmenu_button_up():
	get_tree().change_scene("res://Networking/Lobby2/Lobby2.tscn")


func reset_the_game():
	# HACK: eughagu.
	SyncManager.stop()
	get_tree().change_scene("res://Networking/Lobby/crude_connection.tscn")
