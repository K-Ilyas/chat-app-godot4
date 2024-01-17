class_name ChatWindow extends Panel

var label_message = preload("res://LabelMessage.tscn")

signal message_sent(mess)

@onready var text_edit = $TextEdit
@onready var message_list = $ScrollContainer/VBoxContainer



func _ready():
	Client.connect("list_messages_changed",messages_changed)
	NetworkChat.connect("new_message",print_new_message)


func add_message(chat_message):
	var label_instance = label_message.instantiate()
	# label_instance is not yet in the ChatWindow
	label_instance.set_chat_message(chat_message)
	message_list.add_child(label_instance)
	

func _on_text_edit_text_submitted(new_text):
	var mess_string = text_edit.text
	if mess_string != "":
		message_sent.emit(mess_string)
		text_edit.text = ""
		

func messages_changed(messages):
	for child in message_list.get_children():
		child.queue_free()
	
	for message in messages :
		add_message(message)
	
func print_new_message(message):
	print(message)
	add_message(message)
