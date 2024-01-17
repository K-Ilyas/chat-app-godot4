class_name LabelMessage extends Label


func set_chat_message(new_chat_mess):
	
	var date = Time.get_datetime_dict_from_unix_time(new_chat_mess["timestamp"])
	var formated_date = str( date["day"] )+"-" + str(  date["month"] )+"-"+str( date["year"])+ " " +str(  date["hour"]) +":"+ str( date["minute"])+":"+str( date["second"])
	self.text = "[" + formated_date +"]" + " ["+ str(new_chat_mess["pseudo"])+ " - " +str(new_chat_mess["id"])+"] " + " : " + new_chat_mess["message"]
	
