extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	match get_node("../").get_meta("teleport_location"):
		1:
			get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc1")[0].position.x
			get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc1")[0].position.y+200
		2:
			get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc2")[0].position.x
			get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc2")[0].position.y+200
		3:
			get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc3")[0].position.x
			get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc3")[0].position.y+200
		4:
			get_tree().get_nodes_in_group("Player")[0].position.x = get_tree().get_nodes_in_group("loc4")[0].position.x
			get_tree().get_nodes_in_group("Player")[0].position.y = get_tree().get_nodes_in_group("loc4")[0].position.y+200
		5:
			get_tree().change_scene_to_file("res://scenes/throne_room.tscn")
