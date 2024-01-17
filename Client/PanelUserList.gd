class_name PanelUserList extends Panel

var label_user_instance = preload("res://LabelUser.tscn")
@onready var user_list = $ScrollContainer/VBoxContainer

## [LabelUser] nodes will have their id
## as their name

func _ready():
	Client.connect("list_player_changed",list_player_changed)
	Client.connect("player_removed",player_removed)
	Client.connect("player_added",player_added)
func add_user(id: int, pseudo: String):
	var label_user = label_user_instance.instantiate()
	label_user.id = id
	label_user.pseudo = pseudo
	label_user.name = str(id)
	user_list.add_child(label_user)

func delete_user(id: int):
	var label_user: LabelUser = get_user(id)
	if label_user :
		label_user.queue_free()

func get_user(id: int) -> LabelUser:
	var label_user = user_list.get_node_or_null(str(id))
	return label_user

func player_removed(player):
	$UserCount.text = str(len(Client.players)) +" Users connected"
	delete_user(player["id"])

func player_added(player):
	$UserCount.text = str(len(Client.players)) +" Users connected"
	add_user(player["id"],player["pseudo"])

func list_player_changed(players):
	$UserCount.text = str(len(Client.players)) +" Users connected"
	print(Client.players)
	for child in user_list.get_children():
		child.queue_free()
	for user in Client.players :
		add_user(user["id"],user["pseudo"])
