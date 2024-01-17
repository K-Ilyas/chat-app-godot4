extends Node


signal server_created
signal join_success
signal join_fail
signal player_list_changed
signal player_removed(pid)
signal disconnected

var server_info = {
	used_port = 35555,
	max_players = 50
}

var messages = []



@rpc("any_peer")
func send_message(message):
	var player = Client.players.filter(func(player): return player["id"] == multiplayer.get_remote_sender_id()).front()
	message["id"] = player["id"]
	message["pseudo"] = player["pseudo"]
	print("A message recived from the server",message)
	self.messages.append(message)
	brodcat_message.rpc(message)


@rpc("authority")
func brodcat_message(message):
	print("A message brodcat from the server",message)


