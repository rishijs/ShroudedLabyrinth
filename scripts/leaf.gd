extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	get_child(1).get_child(0).disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if get_tree().get_nodes_in_group("Player")[0] == body:
		if get_tree().get_nodes_in_group("Player")[0].time > get_tree().get_nodes_in_group("Player")[0].start_time:
			if get_child(1).get_child(0).disabled == true:
				await get_tree().create_timer(5).timeout
				get_child(1).get_child(0).disabled = false
				print_debug(1)
			
			if visible == true:
				get_tree().get_nodes_in_group("Player")[0].leaves_collected += 1
				get_node("./").queue_free()
