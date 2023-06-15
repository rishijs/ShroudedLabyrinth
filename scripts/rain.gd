extends CanvasLayer

var time = 0

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time>1:
		if get_tree().get_first_node_in_group("Player").direction == "left":
			get_children()[1].emitting = true
		elif get_tree().get_first_node_in_group("Player").direction == "right":
			get_children()[0].emitting = true	
	if get_tree().get_first_node_in_group("Player").inside == true:
		if get_tree().get_first_node_in_group("Player").direction == "left":
			get_children()[1].visible = false
		if get_tree().get_first_node_in_group("Player").direction == "right":
			get_children()[0].visible = false
	else:
		if get_tree().get_first_node_in_group("Player").direction == "left":
			get_children()[1].visible = true
		if get_tree().get_first_node_in_group("Player").direction == "right":
			get_children()[0].visible = true
		
			
