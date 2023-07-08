extends CharacterBody2D

@export var SPEED = 200.0
@export var flashlight_mode = "Off"
@export var flashlight_switch_delay = 0.5
@export var max_health = 100
@export var max_insanity = 100
@export var max_battery = 100
@export var lerp_strength = 0.1

@export var health = 0
@export var insanity = 0
@export var battery = 0
@export var battery_recharge_rate = 0.3

#N * 100 = value per second
@export var full_power_light_consumption = 0.065
@export var infrared_light_consumption = 0.04
@export var scanner_light_consumption = 0.01
@export var insanity_overtime = 0.15

@export var insanity_cure_high = 0.1
@export var insanity_cure_infrared = 0.225
@export var insanity_cure_scanner = 0.15
@export var insanity_cure_light = 0.25

@export var health_dmg_insane = 0.05
@export var insanity_threshold = max_insanity*.9
@export var low_health_threshold = 30
@export var low_battery_threshold = 20

@export var high_dmg = 1.5
@export var infrared_dmg = 0.7

@export var start_time = 5
@export var dev_mode = false
@export var rotation_speed = 10

var item_equipped = -1
var stats_gained = false
var NPCInteraction = false

var haunted_ghost = false
var haunted_puppet = false
var targetted_enemy_body:CharacterBody2D
var enemy_targetted = false

var in_light = false
var flashlight_switched = false
var time = 0
var time_flashlight_switch = 0
var leaves_collected = 0
var battery_recharging = false
var previous_mode = "Scanner"

var shrines
var shrine_type = "default"
var direction = "None"
var inside = false

var secret_ending = false
var special_ending = false

var blessedimg = Image.load_from_file("res://custom/bird_shrine_activated.png")
var blessedtexture = ImageTexture.create_from_image(blessedimg)
var cursedimg = Image.load_from_file("res://custom/bird_shrine_cursed.png")
var cursedtexture = ImageTexture.create_from_image(cursedimg)

var cursed = false
var blessed = false
var reset = false
var wait_restart = 5
var wait_restart_timer = 0

var deaths = 0
var time_taken = 0

# ready
func _ready():
	shrines = get_tree().get_nodes_in_group("shrine")
	
	if  RandomNumberGenerator.new().randi_range(0,1) == 0:
		direction = "left"
	else:
		direction = "right"
	
	battery = max_battery
	health = max_health
	
	for x in get_tree().get_nodes_in_group("Ghost"):
		add_collision_exception_with(x)
	
# tick
func _process(delta):
	
	if reset == true:
		wait_restart_timer += delta
		if wait_restart_timer >= wait_restart:
			reset = false
			wait_restart_timer =0
		
	if Input.is_action_pressed("restart"):
		position = get_tree().get_first_node_in_group("Spawn").global_position
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		
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
				get_tree().get_first_node_in_group("Item1Sprite").visible = false
			2:
				max_insanity += 100
				max_health -= 75
				insanity_overtime *= 0.75
				stats_gained = true
				get_tree().get_first_node_in_group("Item2Sprite").visible = false
			3:
				max_battery += 50
				max_insanity += 50
				max_health += 50
				insanity_overtime *= 1.25
				stats_gained = true
				get_tree().get_first_node_in_group("Item3Sprite").visible = false
			4:
				high_dmg *= 1.5
				infrared_dmg *= 1.5
				insanity_cure_high *= 1.25
				insanity_cure_infrared *= 1.25
				insanity_cure_scanner *= 1.25
				full_power_light_consumption *= 1.25
				infrared_light_consumption *= 1.25
				scanner_light_consumption *= 1.25
				stats_gained = true
				get_tree().get_first_node_in_group("Item4Sprite").visible = false
		
		if insanity<0:
			insanity = 0
		if insanity > max_insanity:
			insanity = max_insanity
		if health<=0:
			if cursed == true || get_tree().get_first_node_in_group("Puppet").shrine_interacted == true:
				get_tree().change_scene_to_file("res://scenes/darkness_ending.tscn")
			else:
				position = get_tree().get_first_node_in_group("Spawn").global_position
				if reset == false:
					deaths += 1
					health = max_health
					insanity = 0
					battery = max_battery
					reset = true
				
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

		
		var curr_shrine = false
		var shrine_area_ref = null
		for x in shrines:
			for child in x.get_children():
				if child.get_groups().size() > 0:
					if child.get_groups()[0] == "area2d":
						if child.shrine_status == true:
							shrine_area_ref = child
							shrine_type = x.get_groups()[1]
							curr_shrine = true
						
		if curr_shrine == false:
			shrine_type = "default"
		if shrine_type != "default":
			if shrine_area_ref.interacted == false:
				match shrine_type:
					"shrinemain1":
						if Input.is_action_pressed("interact"):
							get_tree().get_nodes_in_group("DoorMaze")[0].visible = false
							get_tree().get_nodes_in_group("DoorMaze")[0].get_children()[0].get_children()[0].disabled = true
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "MazeGate"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							shrine_area_ref.interacted = true					
							get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
							
					"shrinemain2":
						if Input.is_action_pressed("interact"):
							get_tree().get_nodes_in_group("DoorMaze")[0].visible = false
							get_tree().get_nodes_in_group("DoorMaze")[0].get_children()[0].get_children()[0].disabled = true
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "MazeGate"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							shrine_area_ref.interacted = true					
							get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
							
					"shrinesecret":
						if Input.is_action_pressed("interact"):			
							secret_ending = true
							get_tree().get_nodes_in_group("DoorDecoy")[0].visible = false	
							get_tree().get_nodes_in_group("DoorDecoy")[0].get_children()[0].get_children()[0].disabled = true
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "SpecialShrine"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							get_tree().get_nodes_in_group("Puppet")[0].shrine_interacted = true
							shrine_area_ref.interacted = true					
							get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
							
					"shrinegatefake":
						if Input.is_action_pressed("interact") && leaves_collected == 3:				
							leaves_collected -= 3
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "DecoyShrine"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							cursed = true
							shrine_area_ref.get_parent().set_texture(cursedtexture)
							shrine_area_ref.interacted = true					
							get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
							
						elif Input.is_action_pressed("interact"):			
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "NoLeaves"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							
					"shrinegate1":
						if Input.is_action_pressed("interact") && leaves_collected == 3:			
							get_tree().get_nodes_in_group("DoorGate")[0].visible = false
							get_tree().get_nodes_in_group("DoorGate")[0].get_children()[0].get_children()[0].disabled = true
							leaves_collected -= 3
							for x in get_tree().get_nodes_in_group("RainParticles"):
								x.emitting = false
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "ShrineFinal"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							blessed = true
							shrine_area_ref.get_parent().set_texture(blessedtexture)
							shrine_area_ref.interacted = true					
							get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
							
						elif Input.is_action_pressed("interact"):			
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "NoLeaves"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							
					"shrinegate2":
						if Input.is_action_pressed("interact") && leaves_collected == 3:
							get_tree().get_nodes_in_group("DoorGate")[0].visible = false
							get_tree().get_nodes_in_group("DoorGate")[0].get_children()[0].get_children()[0].disabled = true
							leaves_collected -= 3
							for x in get_tree().get_nodes_in_group("RainParticles"):
								x.emitting = false
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "ShrineFinal"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
							blessed = true
							shrine_area_ref.get_parent().set_texture(blessedtexture)
							shrine_area_ref.interacted = true					
							get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
					
						elif Input.is_action_pressed("interact"):			
							get_tree().get_nodes_in_group("GameMessageText")[0].messageSummary = "NoLeaves"
							get_tree().get_nodes_in_group("GameMessageText")[0].messagePending = true
				
		
		if blessed == true:
			insanity = 0
			get_tree().get_nodes_in_group("Rain")[0].left_rain.emitting = false
			get_tree().get_nodes_in_group("Rain")[0].right_rain.emitting = false
			get_tree().get_nodes_in_group("DarkenScene")[0].visible = false
		
		if cursed == true:
			insanity = max_insanity
			health -= 0.2
					
		if flashlight_switched == false:
			if Input.is_action_pressed("light_mode"):
				if flashlight_mode != "Off":
					flashlight_mode = "Off"
				elif flashlight_mode == "Off":
					flashlight_mode = previous_mode
				flashlight_switched = true
				
			if Input.is_action_pressed("scanner_mode"):
				flashlight_mode = "Scanner"
				previous_mode = "Scanner"
				flashlight_switched = true
				
			if Input.is_action_pressed("infrared_mode"):
				flashlight_mode = "Infrared"
				previous_mode =  "Infrared"
				flashlight_switched = true
				
			if Input.is_action_pressed("high_power_mode"):
				flashlight_mode = "HighPower"
				previous_mode = "HighPower"
				flashlight_switched = true
		else:
			time_flashlight_switch +=delta;
			if time_flashlight_switch >flashlight_switch_delay:
				time_flashlight_switch = 0
				flashlight_switched=false
				
		if enemy_targetted == true:
			match flashlight_mode:
				"HighPower":
					targetted_enemy_body.health -= high_dmg
					targetted_enemy_body.visible = true
				"Infrared":
					targetted_enemy_body.health -= infrared_dmg
					targetted_enemy_body.visible = true
				
	
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
	
	if velocity.x >= 0:
		get_child(0).flip_v = false
	elif velocity.x < 0:
		get_child(0).flip_v = true
		
	if Input.is_action_pressed("aim"):
		look_at(get_global_mouse_position())
		velocity = velocity * 0.85
	elif velocity.length() > 0:
		rotation = -velocity.angle_to(Vector2(1, 0))
		
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0:
		if body.get_groups()[0] == "Ghost":
			targetted_enemy_body = body
			enemy_targetted = true
			if flashlight_mode == "HighPower" || flashlight_mode == "Infrared":
				body.visible = true
				
	if body.get_parent().get_groups().size() > 0:
		if body.get_parent().get_groups()[0] == "Leaf":
			if flashlight_mode == "HighPower" || flashlight_mode == "Scanner":
				body.get_parent().visible = true


func _on_area_2d_body_exited(body):
	if body.get_groups().size() > 0:
		if body.get_groups()[0] == "Ghost":
			enemy_targetted = false
			body.visible = false
			
	if body.get_parent().get_groups().size() > 0:
		if body.get_parent().get_groups()[0] == "Leaf":
			body.get_parent().visible = false
