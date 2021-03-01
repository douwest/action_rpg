extends Node

export var SERVER_PORT: int = 8080
export var MAX_PLAYERS: int = 3

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
