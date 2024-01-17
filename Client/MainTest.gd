extends Control

@onready var chat_window: ChatWindow = $ChatWindow
@onready var time  = $time
signal new_message(message)


func _ready():
	NetworkClock.connect("clock_changed",clock_changed)

func _on_chat_window_message_sent(mess: String):
	# create the ChatMessage instance
	var chat_message = ChatMessage.new(mess)
	NetworkChat.send_message_input({"id" : null,"pseudo" :null, "message":chat_message.mess_content,"timestamp":chat_message.timestamp})
	#chat_window.add_message(chat_message)
	
func clock_changed(time):
	var date = Time.get_datetime_dict_from_unix_time(time)
	var formated_date = str( date["day"] )+"-" + str(  date["month"] )+"-"+str( date["year"])+ " " +str(  date["hour"]) +":"+ str( date["minute"])+":"+str( date["second"])
	$time.text = formated_date


func _on_button_pressed():
	Client.emit_signal("disconnected")
