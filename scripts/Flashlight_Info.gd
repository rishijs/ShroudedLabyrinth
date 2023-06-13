extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match get_tree().get_nodes_in_group("Player")[0].flashlight_mode:
		"HighPower":
			color = Color(255,255,255)
			get_children()[1].self_modulate = Color(255,255,255,1)
			get_children()[1].text = "HI"
		"Infrared":
			color = Color(255,0,0)
			get_children()[1].self_modulate = Color(255,0,0,0.7)
			get_children()[1].text = "IR"
		"Scanner":
			color = Color(0,255,255)
			get_children()[1].self_modulate = Color(0,255,255,0.6)
			get_children()[1].text = "Sc"
		"Off":
			color = Color(0,0,0)
			get_children()[1].self_modulate = Color(66,66,66,0.5)
			get_children()[1].text = "OFF"
