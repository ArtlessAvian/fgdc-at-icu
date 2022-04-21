# Lifted from the netcode tutorial
extends Node

# Lifted from the netcode tutorial
onready var host_field = $CanvasLayer/MarginContainer/GridContainer/HostField
onready var port_field = $CanvasLayer/MarginContainer/GridContainer/PortField


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	SyncManager.connect("sync_started", self, "_on_SyncManager_sync_started")
	SyncManager.connect("sync_stopped", self, "_on_SyncManager_sync_stopped")
	SyncManager.connect("sync_lost", self, "_on_SyncManager_sync_lost")
	SyncManager.connect("sync_regained", self, "_on_SyncManager_sync_regained")
	SyncManager.connect("sync_error", self, "_on_SyncManager_sync_error")


func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
	# Setup the match using 'match_info' and disable anything we don't
	# want or need during replay.
	pass


func _on_Server_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(port_field.text), 1)
	get_tree().network_peer = peer

	if not SyncReplay.active:
		SyncManager.start_logging("res://dump/" + str(OS.get_unix_time()) + "-host.log")


func _on_Client_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(host_field.text, int(port_field.text))
	get_tree().network_peer = peer

	if not SyncReplay.active:
		SyncManager.start_logging("res://dump/" + str(OS.get_unix_time()) + "-client.log")


func _on_Local_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(31415, 1)
	get_tree().network_peer = peer

	$CanvasLayer/MarginContainer.visible = false
	$Match/Game/Fighter2.controlled_by = "c0"

	SyncManager.start()
	print("TODO: Testing local button pushed")


func _on_Mash_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(31415, 1)
	get_tree().network_peer = peer

	$CanvasLayer/MarginContainer.visible = false
	$Match/Game/Fighter2.is_mash = true

	SyncManager.start()


func _on_Test_button_up():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(31415, 1)
	get_tree().network_peer = peer

	for i in range(50):
		print("TEST")
		$CanvasLayer/MarginContainer.visible = false
		$Match/Game/Fighter1.fixed_position.y = -65536 * 30
		$Match/Game/Fighter1.grounded = false
		# $Match/Game/Fighter2.fixed_position.x = 1
		# $Match/Game/Fighter1/Hitboxes.new_attack()
		$Match/Game/Fighter1.state = $Match/Game/Fighter1.moveset.j_light
		# $Match/Game/Fighter2.state = $Match/Game/Fighter2.moveset.walk
		$Match/Game/Fighter1.state_time = 0

		if not SyncReplay.active:
			SyncManager.start_logging("res://dump/test.log")

		SyncManager.start()
		yield(get_tree().create_timer(0.3), "timeout")
		SyncManager.stop()
		# print($Match/Game/Fighter2.fixed_position.x)
		# if $Match/Game/Fighter2.fixed_position.x != 5735125:
		if not $Match/Game/Fighter1/Hitboxes/SGCollisionShape2D.disabled:
			print("Icecream machine broke")
			break
		yield(get_tree().create_timer(0.1), "timeout")

	print("success!")


# NETWORKING====================================================


func _on_network_peer_connected(peer_id: int):
	print("success!")
	SyncManager.add_peer(peer_id)

	var game_instance = find_node("Game", true, false)
	print(game_instance)

	game_instance.get_node("Fighter1").set_network_master(1)
	if get_tree().is_network_server():
		game_instance.get_node("Fighter2").set_network_master(peer_id)
	else:
		game_instance.get_node("Fighter2").set_network_master(
			get_tree().get_network_unique_id()
		)

	# Tried reordering everything below here. it worked before, but it doesn't seem to work anymore.
	$CanvasLayer/MarginContainer.visible = false
	if get_tree().is_network_server():
		yield(get_tree().create_timer(0.2), "timeout")
		SyncManager.start()


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
