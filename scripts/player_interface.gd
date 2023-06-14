extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match get_tree().get_first_node_in_group("Player").leaves_collected:
		0:
			get_tree().get_first_node_in_group("leaf1text").visible = false
			get_tree().get_first_node_in_group("leaf2text").visible = false
			get_tree().get_first_node_in_group("leaf3text").visible = false
		1:
			get_tree().get_first_node_in_group("leaf1text").visible = true
			get_tree().get_first_node_in_group("leaf2text").visible = false
			get_tree().get_first_node_in_group("leaf3text").visible = false
		2:
			get_tree().get_first_node_in_group("leaf1text").visible = true
			get_tree().get_first_node_in_group("leaf2text").visible = true
			get_tree().get_first_node_in_group("leaf3text").visible = false
		3:
			get_tree().get_first_node_in_group("leaf1text").visible = true
			get_tree().get_first_node_in_group("leaf2text").visible = true
			get_tree().get_first_node_in_group("leaf3text").visible = true
