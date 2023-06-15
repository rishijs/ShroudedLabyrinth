extends TextureRect



func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	match get_child(0).get_groups()[0]:
		"Item1Button":
			get_tree().get_nodes_in_group("Player")[0].item_equipped = 1
		"Item2Button":
			get_tree().get_nodes_in_group("Player")[0].item_equipped = 2
		"Item3Button":
			get_tree().get_nodes_in_group("Player")[0].item_equipped = 3
		"Item4Button":
			get_tree().get_nodes_in_group("Player")[0].item_equipped = 4
	get_tree().get_nodes_in_group("ItemSelect")[0].visible = false
	get_tree().get_nodes_in_group("NPCPrompts")[0].visible = true
	get_tree().get_nodes_in_group("NPC")[0].extra_messages = true
	get_tree().get_nodes_in_group("NPC")[0].selecting_item = false
