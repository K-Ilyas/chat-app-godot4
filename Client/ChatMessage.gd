class_name ChatMessage extends Object

static var nb_messages = 0
var id: int
var mess_content: String
var timestamp: float

func _init(mess_content: String):
	id = nb_messages
	nb_messages += 1
	self.mess_content = mess_content
	self.timestamp = NetworkClock.client_clock
	
