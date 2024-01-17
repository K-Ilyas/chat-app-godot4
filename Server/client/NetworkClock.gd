extends Node






@rpc("any_peer")
func FetchServerTime(clientTime):
	var id =  multiplayer.get_remote_sender_id()
	print("Clinet send time to the server" + str(clientTime))
	#for i in range(110000000):
		#print(i)
	ReturnServerTime.rpc_id(id,Time.get_unix_time_from_system(),clientTime)


@rpc("authority")
func ReturnServerTime(serverTime,clientTime):
	print("Server send time to the clinet" + str(serverTime) + str(clientTime))
