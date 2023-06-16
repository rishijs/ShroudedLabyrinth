extends Sprite2D

@export var battery_drain_rate = 1
@export var health = 9999

var time = 0
var activated = false

var doomsday = false
var doomsday_timer = 0
var doomsday_delay = 3
var player_in_range = false

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if time > 1:
		activated = true
		if doomsday == true:
			doomsday_timer += delta
			if doomsday_timer > doomsday_delay && player_in_range == true:
				get_tree().get_first_node_in_group("Player").health = 0
			elif doomsday_timer > doomsday_delay && player_in_range == true:
				doomsday = false
				doomsday_timer = 0
				
	if activated && get_tree().get_first_node_in_group("Player").haunted_puppet:
		get_tree().get_first_node_in_group("Player").battery -= battery_drain_rate
	if health <= 0:
		queue_free()



func _on_battery_drain_body_entered(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		get_tree().get_first_node_in_group("Player").haunted_puppet = true


func _on_one_shot_body_entered(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		doomsday = true
		player_in_range = true


func _on_one_shot_body_exited(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		player_in_range = false
