extends CharacterBody2D

@export var SPEED = 200.0
@export var flashlight_mode = "Off"
@export var flashlight_switch_delay = 0.5
@export var max_health = 150
@export var max_insanity = 150
@export var max_battery = 150
@export var lerp_strength = 0.1

@export var health = 0
@export var insanity = 0
@export var battery = 0
@export var battery_recharge_rate = 0.09

#N * 100 = value per second
@export var full_power_light_consumption = 0.065
@export var infrared_light_consumption = 0.04
@export var scanner_light_consumption = 0.01
@export var insanity_overtime = 0.15

@export var insanity_cure_high = 0.1
@export var insanity_cure_infrared = 0.225
@export var insanity_cure_scanner = 0.15
@export var insanity_cure_light = 0.2

@export var health_dmg_insane = 0.05
@export var insanity_threshold = max_insanity*.9
@export var low_health_threshold = 30
@export var low_battery_threshold = 20

@export var high_dmg = 1
@export var infrared_dmg = 0.1
@export var scanner_dmg = 0

@export var start_time = 5
@export var dev_mode = true

var item_equipped = -1
var stats_gained = false

var in_light = false
var flashlight_switched = false
var time = 0
var time_flashlight_switch = 0
var leaves_collected = 0
var battery_recharging = false

var shrines
var shrine_type = "default"
var direction = "None"
var inside = false

var NPCInteraction = false

var secret_ending = false

# ready
func _ready():
	shrines = get_tree().get_nodes_in_group("shrine")
	
	if  RandomNumberGenerator.new().randi_range(0,1) == 0:
		direction = "left"
	else:
		direction = "right"
	
	battery = max_battery
	health = max_health
	
# tick
func _process(delta):
	
	if get_tree().get_current_scene().get_name() == "main":
		time += delta
		
		if dev_mode:
			insanity=0
			health=max_health
			battery=max_battery
		
		match item_equipped && stats_gained == false:
			1:
				max_battery -= 50
				battery -= 50
				full_power_light_consumption *= 0.5
				infrared_light_consumption *= 0.5
				scanner_light_consumption *= 0.5
				stats_gained = true
			2:
				max_insanity += 100
				max_health -= 75
				insanity_overtime *= 0.75
				stats_gained = true
			3:
				max_battery += 50
				max_insanity += 50
				max_health += 50
				insanity_overtime *= 1.25
				stats_gained = true
			4:
				high_dmg *= 1.5
				infrared_dmg *= 1.5
				scanner_dmg *= 1.5
				insanity_cure_high *= 1.25
				insanity_cure_infrared *= 1.25
				insanity_cure_scanner *= 1.25
				full_power_light_consumption *= 1.25
				infrared_light_consumption *= 1.25
				scanner_light_consumption *= 1.25
				stats_gained = true
		
		if insanity<0:
			insanity = 0
		if health<=0:
			if secret_ending == true:
				get_tree().change_scene_to_file("res://scenes/special_ending.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		if battery<0:
			battery = 0
		if battery_recharging == true:
			battery += battery_recharge_rate
			
		if insanity > insanity_threshold:
			health -= health_dmg_insane
		
		if in_light:
			insanity -= insanity_cure_light
			
		if insanity<max_insanity && flashlight_mode!="HighPower" && in_light == false && time > start_time:
			insanity += insanity_overtime
			
		if battery>0:
			match flashlight_mode:
				"HighPower":
					battery -= full_power_light_consumption
					insanity -= insanity_cure_high
					get_tree().get_first_node_in_group("Flashlight").visible = true
					get_tree().get_first_node_in_group("Flashlight").set_color("ffffff")
					get_tree().get_first_node_in_group("Flashlight").energy = 1.5
				"Infrared":
					battery -= infrared_light_consumption
					insanity -= insanity_cure_infrared
					get_tree().get_first_node_in_group("Flashlight").visible = true
					get_tree().get_first_node_in_group("Flashlight").set_color("880808")
					get_tree().get_first_node_in_group("Flashlight").energy = 2.5
				"Scanner":
					battery -= scanner_light_consumption
					insanity -= insanity_cure_scanner
					get_tree().get_first_node_in_group("Flashlight").visible = true
					get_tree().get_first_node_in_group("Flashlight").set_color("0080FE")
					get_tree().get_first_node_in_group("Flashlight").energy = 2
				"Off":
					get_tree().get_first_node_in_group("Flashlight").visible = false
		else:
			flashlight_mode = "Off"
			get_tree().get_first_node_in_group("Flashlight").visible = false
		
		if(Input.is_action_pressed("emergency_turn_light_off")):
			flashlight_mode = "Off"
		
		var curr_shrine = false
		for x in shrines:
			for child in x.get_children():
				if child.get_groups().size() > 0:
					if child.get_groups()[0] == "area2d":
						if child.shrine_status == true:
							shrine_type = x.get_groups()[1]
							curr_shrine = true
						
		if curr_shrine == false:
			shrine_type = "default"
			
		match shrine_type:
			"shrinemain1":
				if Input.is_action_pressed("interact"):
					get_tree().get_nodes_in_group("DoorMaze")[0].visible = false
					get_tree().get_nodes_in_group("DoorMaze")[0].get_children()[0].get_children()[0].disabled = true
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "MazeGate"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
					
			"shrinemain2":
				if Input.is_action_pressed("interact"):
					get_tree().get_nodes_in_group("DoorMaze")[0].visible = false
					get_tree().get_nodes_in_group("DoorMaze")[0].get_children()[0].get_children()[0].disabled = true
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "MazeGate"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
					
			"shrinesecret":
				if Input.is_action_pressed("interact"):
					secret_ending = true
					get_tree().get_nodes_in_group("DoorDecoy")[0].visible = false	
					get_tree().get_nodes_in_group("DoorDecoy")[0].get_children()[0].get_children()[0].disabled = true
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "SpecialShrine"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
					
			"shrinegatefake":
				if Input.is_action_pressed("interact") && leaves_collected == 3:
					get_tree().change_scene_to_file("res://scenes/game_over.tscn")
					leaves_collected -= 3
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "DecoyShrine"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
				elif Input.is_action_pressed("interact"):
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "NoLeaves"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
					
			"shrinegate1":
				if Input.is_action_pressed("interact") && leaves_collected == 3:
					get_tree().get_nodes_in_group("DoorGate")[0].visible = false
					get_tree().get_nodes_in_group("DoorGate")[0].get_children()[0].get_children()[0].disabled = true
					leaves_collected -= 3
					for x in get_tree().get_nodes_in_group("Rain"):
						x.emitting = false
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "ShrineFinal"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
				elif Input.is_action_pressed("interact"):
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "NoLeaves"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
					
			"shrinegate2":
				if Input.is_action_pressed("interact") && leaves_collected == 3:
					get_tree().get_nodes_in_group("DoorGate")[0].visible = false
					get_tree().get_nodes_in_group("DoorGate")[0].get_children()[0].get_children()[0].disabled = true
					leaves_collected -= 3
					for x in get_tree().get_nodes_in_group("Rain"):
						x.emitting = false
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "ShrineFinal"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
				elif Input.is_action_pressed("interact"):
					get_tree().get_nodes_in_group("Player")[0].messageSummary = "NoLeaves"
					get_tree().get_nodes_in_group("Player")[0].messagePending = true
					
		if flashlight_switched == false:
			match flashlight_mode:
				"HighPower":
					if Input.is_action_pressed("light_mode"):
						flashlight_mode = "Off"
						flashlight_switched = true
				"Infrared":
					if Input.is_action_pressed("light_mode"):
						flashlight_mode = "HighPower"
						flashlight_switched = true
				"Scanner":
					if Input.is_action_pressed("light_mode"):
						flashlight_mode = "Infrared"
						flashlight_switched = true
				"Off":
					if Input.is_action_pressed("light_mode"):
						flashlight_mode = "Scanner"
						flashlight_switched = true
		else:
			time_flashlight_switch +=delta;
			if time_flashlight_switch >flashlight_switch_delay:
				time_flashlight_switch = 0
				flashlight_switched=false
	
# movement
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var directionVector = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	var movingx = false
	var movingy = false
	var targetVelocity = Vector2.ZERO
	
	if direction.length() > 1:
		directionVector = directionVector.normalized()
		
	if directionVector.x:
		targetVelocity.x = directionVector.x * SPEED
		movingx = true
	else:
		targetVelocity.x = move_toward(velocity.x, 0, SPEED)
		movingx = false

	if directionVector.y:
		targetVelocity.y = directionVector.y * SPEED
		movingy = true
	else:
		targetVelocity.y = move_toward(velocity.y, 0, SPEED)
		movingy = false
	
	if inside==false && (movingx || movingy):
		if direction == "right":
			targetVelocity.x += SPEED/3
		if direction == "left":
			targetVelocity.x -= SPEED/3
	elif (movingx || movingy):
		if direction == "right":
			targetVelocity.x += SPEED/5
		if direction == "left":
			targetVelocity.x -= SPEED/5

	velocity = velocity.lerp(targetVelocity, lerp_strength)
	
	if velocity.length() > 0:
		rotation = -velocity.angle_to(Vector2(1, 0))
		
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	pass #enemies / scan


func _on_area_2d_body_exited(body):
	pass #enemies / scan


func _on_area_2d_area_entered(area):
	pass #leaves scan


func _on_area_2d_area_exited(area):
	pass #leaves scan
