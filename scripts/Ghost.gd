extends CharacterBody2D

@export var insanity_increase = 1
@export var insanity_increase_chase = 0.8
@export var health_dmg_chase = 0.25
@export var health = 50
@export var max_health = 50
@export var speed = 60
@export var chase_speed = 90
@export var healing = 2

var time = 0
var activated = false
var flip_delay = 1
var flip_timer = 0
var flipped = false

@export var teleport_timer = 7
@export var sanguine = 7
@export var teleport_cooldown = 100
@export var teleport_amplitude = 150

@export var patrolling = true

var round_trip = false
var start = null
var end = null

func _ready():
	start = global_position
	end = get_child(3).global_position
	get_child(4).target_position = end
	add_collision_exception_with(get_tree().get_first_node_in_group("Player"))
	visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	time += delta
		
	if health < max_health && teleport_timer > sanguine:
		health += healing
	
	if flipped:
		if flip_timer < flip_delay:
			flip_timer += delta
		else:
			flip_timer = 0
			flipped = false
	
	if time > 1:
		activated = true

	if activated && get_tree().get_first_node_in_group("Player").haunted_ghost:
		if patrolling == true:
			get_tree().get_first_node_in_group("Player").insanity += insanity_increase
		else:
			get_tree().get_first_node_in_group("Player").insanity += insanity_increase_chase
			get_tree().get_first_node_in_group("Player").health -= health_dmg_chase
	if health <= 0:
		queue_free()

func _physics_process(delta):
	
	if health < max_health:
		var direction = global_position.direction_to(get_tree().get_first_node_in_group("Player").global_position)
		velocity = direction * chase_speed
		move_and_slide()
		teleport_timer += delta
		end = get_tree().get_first_node_in_group("Player").global_position
		if teleport_timer > teleport_cooldown:
			teleport_timer = 0
			visible = false
			position += direction * teleport_amplitude
		
	elif patrolling == true:
		if round_trip == true:
			var direction = global_position.direction_to(start)
			velocity = direction * speed
		else:
			var direction = global_position.direction_to(end)
			velocity = direction * speed
		move_and_slide()
	
	if velocity.x > 0 && flipped == false:
		get_child(1).scale.x = -1
		flipped = true
	elif velocity.x < 0 && flipped == false:
		get_child(1).scale.x = 1
		flipped = true
	
	
func _on_area_2d_body_entered(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		get_tree().get_first_node_in_group("Player").haunted_ghost = true


func _on_area_2d_body_exited(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		get_tree().get_first_node_in_group("Player").haunted_ghost = false


func _on_navigation_agent_2d_target_reached():
	if round_trip == false:
		get_child(4).target_position = start
		round_trip = true
	else:
		get_child(4).target_position = end
		round_trip = false
		
