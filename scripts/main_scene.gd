extends Node

@onready var join_btn: Button = $CenterContainer/VBoxContainer/Join
@onready var hud: CenterContainer = $CenterContainer

var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func _ready():
	Engine.max_fps = 60
	#join_btn.pressed.connect(_on_join_pressed)
	Steam.steamInitEx(true, 480, true)
	#print("Steamworks status: ", api.status)
	Steam.join_requested.connect(_on_join_pressed)

func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 2)
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconnected)
	hud.hide()
	_on_peer_connected()

func _on_join_pressed(lobby_id: int, steam_id: int):
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer
	hud.hide()

func _on_peer_connected(id: int = 1):
	var player_scene = load("res://scenes/player.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	add_child(player_instance, true)

func _on_peer_disconnected(id: int):
	for child in get_children():
		if child is Player and child.name == str(id):
			child.queue_free()
