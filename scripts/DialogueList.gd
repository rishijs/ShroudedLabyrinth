extends ColorRect

var message_delay = 5
var time = 0
var selected_item = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_item:
		time += delta
		if time > message_delay:
			time = 0
			selected_item = false
			visible = true
			get_tree().get_nodes_in_group("DialogueList").clear()
			get_tree().get_nodes_in_group("NPCMessage")[0].visible = false

func _on_item_list_item_selected(index):
	selected_item = true
	get_tree().get_nodes_in_group("NPCMessage")[0].visible = true
	visible = false
	get_tree().get_nodes_in_group("NPCMessage")[0].get_child(0).text = get_tree().get_nodes_in_group("NPC")[0].extra_dialogue[index]
	
	if index == 0:
		get_tree().get_nodes_in_group("NPC")[0].interacting = false
		get_tree().get_nodes_in_group("NPC")[0].extra_messages = false
		
	if index == get_tree().get_nodes_in_group("NPC")[0].extra_dialogue.size()-2:
		get_child(0).get_child(0).get_child(0).remove_item(index)
	
	if index == get_tree().get_nodes_in_group("NPC")[0].extra_dialogue.size()-1:
		get_tree().get_nodes_in_group("NPC")[0].selecting_item = true
		get_child(0).get_child(0).get_child(0).remove_item(index)
