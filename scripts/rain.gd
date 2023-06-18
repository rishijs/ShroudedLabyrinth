extends CanvasLayer

var time = 0

var left_rain = null
var right_rain = null

func _ready():
	left_rain = get_children()[1]
	right_rain = get_children()[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time>1:
		if get_tree().get_first_node_in_group("Player").direction == "left":
			left_rain.emitting = true
		elif get_tree().get_first_node_in_group("Player").direction == "right":
			right_rain.emitting = true	
	if get_tree().get_first_node_in_group("Player").inside == true:
		if get_tree().get_first_node_in_group("Player").direction == "left":
			left_rain.visible = false
		if get_tree().get_first_node_in_group("Player").direction == "right":
			right_rain.visible = false
	else:
		if get_tree().get_first_node_in_group("Player").direction == "left":
			left_rain.visible = true
		if get_tree().get_first_node_in_group("Player").direction == "right":
			right_rain.visible = true
		
			
