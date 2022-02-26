extends SGFixedNode2D


func _ready():
	if self in get_tree().root.get_children():
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(25565, 1)
		get_tree().network_peer = peer
		$Fighter1.set_network_master(get_tree().get_network_unique_id())
		# $Fighter2.set_network_master(15)
		SyncManager.start()
