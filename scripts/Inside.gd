extends Area2D

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta


func _on_area_2d_body_entered(body):
	if time > 3:
		if get_tree().get_first_node_in_group("Player") == body:
			get_tree().get_first_node_in_group("Player").inside = true
		if get_tree().get_first_node_in_group("Ghost") == body:
			get_tree().get_first_node_in_group("Ghost").velocity = Vector2.ZERO
			await get_tree().create_timer(3.0).timeout
			get_tree().get_first_node_in_group("Ghost").position = get_tree().get_first_node_in_group("Ghost").start
			get_tree().get_first_node_in_group("Ghost").patrolling = true
			get_tree().get_first_node_in_group("Ghost").health = get_tree().get_first_node_in_group("Ghost").max_health
