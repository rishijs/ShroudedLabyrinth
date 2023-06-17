extends Area2D

var activated = false
var time = 0
var direction

var shrine_status = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	if time>get_tree().get_first_node_in_group("Player").start_time && activated == false:
		activated = true
		direction = get_tree().get_nodes_in_group("Player")[0].direction
	
		match get_node("../").get_groups()[1]:
			"shrinemain1":
				if direction == "left":
					get_children()[0].disabled = true
					get_tree().get_nodes_in_group("BaseM1")[0].visible = true
					for child in get_node("../").get_children():
						child.visible = false
			"shrinemain2":
				if direction == "right":
					get_children()[0].disabled = true
					get_tree().get_nodes_in_group("BaseM2")[0].visible = true
					for child in get_node("../").get_children():
						child.visible = false
			"shrinegate1":
				if direction == "right":
					get_children()[0].disabled = true
					get_tree().get_nodes_in_group("BaseG1")[0].visible = true
					for child in get_node("../").get_children():
						child.visible = false
			"shrinegate2":
				if direction == "left":
					get_children()[0].disabled = true
					get_tree().get_nodes_in_group("BaseG2")[0].visible = true
					for child in get_node("../").get_children():
						child.visible = false


func _on_body_entered(body):
	if activated:
		if get_tree().get_nodes_in_group("Player")[0]:
			if get_tree().get_nodes_in_group("Player")[0].NPCInteraction == false:	
				get_tree().get_nodes_in_group("InteractionInterface")[0].visible = true	
				if get_groups()[1] != "shrinesecret":
					get_tree().get_nodes_in_group("Player")[0].in_light = true
				shrine_status = true
				
		if get_tree().get_first_node_in_group("Ghost") == body:
			body.visible = true


func _on_body_exited(body):
	if activated && get_tree().get_nodes_in_group("InteractionInterface").size() > 0:
		if get_tree().get_nodes_in_group("Player")[0]:
			if get_tree().get_nodes_in_group("Player")[0].NPCInteraction == false:	
				get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
				get_tree().get_nodes_in_group("Player")[0].in_light = false
				shrine_status = false
				
		if get_tree().get_first_node_in_group("Ghost") == body:
			body.visible = false
