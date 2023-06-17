extends CharacterBody2D

@export var insanity_increase = 0.2
@export var health = 50
@export var speed = 1


var time = 0
var activated = false

func _ready():
	get_child(2).max_value = health
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if time > 1 && activated == false:
		activated = true
		get_child(2).value = health


	if activated && get_tree().get_first_node_in_group("Player").haunted_ghost:
		get_tree().get_first_node_in_group("Player").insanity += insanity_increase
	if health <= 0:
		queue_free()

func _physics_process(delta):
	
	
	var direction = global_position.direction_to(get_tree().get_first_node_in_group("Player").global_position)
	velocity = direction * speed
	
	move_and_slide()
	
	
func _on_area_2d_body_entered(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		get_tree().get_first_node_in_group("Player").haunted_ghost = true


func _on_area_2d_body_exited(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		get_tree().get_first_node_in_group("Player").haunted_ghost = false
