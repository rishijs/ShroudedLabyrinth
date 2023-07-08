extends CharacterBody2D

@export var battery_drain_rate = 1
@export var health = 9999
@export var speed = 120
@export var lantern_slow_timer = 3

var lantern_slow = false

var time = 0
var activated = false

var doomsday = false
var doomsday_timer = 0
@export var doomsday_delay = 3

@export var warning_dmg = 0.05
@export var drain_dmg = 0.01
@export var insanity_rate = 1

var warning_close = false
var warning_doomsday = false
var player_in_range = false

@export var jump_cooldown = 2
@export var jump_distance = 150
@export var jump_timer = 0

var shrine_interacted = false
var teleport = true
var start_movement = false

var teleport_location = null
@export var waiting_time = 8
var waiting_timer = 0

func _ready():
	teleport_location = get_child(4).global_position
	for x in get_tree().get_first_node_in_group("Lanterns").lanterns:
		add_collision_exception_with(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if shrine_interacted == true:
		
		waiting_timer += delta
		if teleport == true:
			position = teleport_location
			teleport = false
		
		if time > 1:
			activated = true
			if doomsday == true:
				doomsday_timer += delta
				get_tree().get_first_node_in_group("Player").health -= warning_dmg
				warning_doomsday = true
				if doomsday_timer > doomsday_delay && player_in_range == true:
					get_tree().get_first_node_in_group("Player").health = 0
				elif doomsday_timer > doomsday_delay && player_in_range == false:
					doomsday = false
					doomsday_timer = 0
					
	if activated && get_tree().get_first_node_in_group("Player").haunted_puppet:
		get_tree().get_first_node_in_group("Player").battery -= battery_drain_rate
	
	if warning_close == true:
		get_tree().get_first_node_in_group("Player").health -= drain_dmg
		get_tree().get_first_node_in_group("Player").insanity += insanity_rate

func _physics_process(delta):
	if shrine_interacted:
		if lantern_slow == true:
			await get_tree().create_timer(lantern_slow_timer).timeout
			lantern_slow = false
		elif waiting_timer > waiting_time:
			var direction = global_position.direction_to(get_tree().get_first_node_in_group("Player").global_position)
			velocity = direction * speed
			
			jump_timer += delta
			if jump_timer > jump_cooldown:
				jump_timer = 0
				visible = true
				position += direction * jump_distance
			elif jump_timer > jump_cooldown/2:
				visible = false
				
			move_and_slide()

func _on_battery_drain_body_entered(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		get_tree().get_first_node_in_group("Player").haunted_puppet = true
		warning_close = true


func _on_one_shot_body_entered(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		doomsday = true
		player_in_range = true
	if activated && get_tree().get_first_node_in_group("shrinegate1") == body:
		get_tree().get_first_node_in_group("Player").special_ending = true
		get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "PuppetDefeated"
		get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
		queue_free()
	if activated && get_tree().get_first_node_in_group("shrinegate2") == body:
		get_tree().get_first_node_in_group("Player").special_ending = true
		get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "PuppetDefeated"
		get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
		queue_free()


func _on_one_shot_body_exited(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		player_in_range = false


func _on_battery_drain_body_exited(body):
	if activated && get_tree().get_first_node_in_group("Player") == body:
		warning_close = false
