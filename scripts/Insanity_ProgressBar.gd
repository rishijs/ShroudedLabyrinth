extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_tree().get_nodes_in_group("Insanity")[0].get_children()[0].value = get_tree().get_nodes_in_group("Player")[0].insanity
	
	if get_tree().get_nodes_in_group("Player")[0].insanity > get_tree().get_nodes_in_group("Player")[0].insanity_threshold:
		get_tree().get_nodes_in_group("InsanityText")[0].self_modulate = Color(255,0,0,1)
	else:
		get_tree().get_nodes_in_group("InsanityText")[0].self_modulate = Color(66,66,66,0.6)
