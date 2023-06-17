extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if get_tree().get_nodes_in_group("Player")[0] == body:
		match get_node("../").get_meta("teleport_location"):
			1:
				get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc1")[0].position.x
				get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc1")[0].position.y+300
			2:
				get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc2")[0].position.x
				get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc2")[0].position.y+300
			3:
				get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc3")[0].position.x
				get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc3")[0].position.y+300
			4:
				get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc4")[0].position.x
				get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc4")[0].position.y+300
			5:
				if get_tree().get_first_node_in_group("Player").secret_ending == false:
					get_tree().change_scene_to_file("res://scenes/throne_room.tscn")
				else:
					get_tree().change_scene_to_file("res://scenes/special_ending.tscn")
