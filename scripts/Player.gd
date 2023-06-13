extends CharacterBody2D

@export var SPEED = 200.0
@export var direction = "None"
@export var flashlight_mode = "Off"
@export var flashlight_switch_delay = 0.5
@export var max_health = 100
@export var max_insanity = 100
@export var max_battery = 100
@export var lerp_strength = 0.1

@export var health = max_health
@export var insanity = 0
@export var battery = max_battery

#N * 100 = value per second
@export var full_power_light_consumption = 0.1
@export var infrared_light_consumption = 0.06
@export var scanner_light_consumption = 0.03

@export var insanity_cure_high = 0.1
@export var insanity_cure_infrared = 0.225
@export var insanity_cure_scanner = 0.15

@export var health_dmg_insane = 0.05
@export var insanity_threshold = 90
@export var low_health_threshold = 30
@export var low_battery_threshold = 20

@export var in_light = false

var flashlight_switched = false
var time = 0

var shrines
var shrine_type = "default"

# ready
func _ready():
	shrines = get_tree().get_nodes_in_group("shrine")
	
	if  RandomNumberGenerator.new().randi_range(0,1) == 0:
		direction = "left"
	else:
		direction = "right"
	
# tick
func _process(delta):
	
	if insanity<0:
		insanity = 0
	if health<0:
		health = 0
	if battery<0:
		battery = 0
		
	if insanity > insanity_threshold:
		health -= health_dmg_insane
	
	if in_light:
		insanity -= 0.15
		
	if insanity<100 && flashlight_mode!="HighPower" && in_light == false:
		insanity += 0.25
		
	if battery>0:
		match flashlight_mode:
			"HighPower":
				battery -= full_power_light_consumption
				insanity -= insanity_cure_high
			"Infrared":
				battery -= infrared_light_consumption
				insanity -= insanity_cure_infrared
			"Scanner":
				battery -= scanner_light_consumption
				insanity -= insanity_cure_scanner
	else:
		flashlight_mode = "Off"
	
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
		"shrinemain2":
			if Input.is_action_pressed("interact"):
				get_tree().get_nodes_in_group("DoorMaze")[0].visible = false
				get_tree().get_nodes_in_group("DoorMaze")[0].get_children()[0].get_children()[0].disabled = true
		"shrinesecret":
			if Input.is_action_pressed("interact"):
				get_tree().get_nodes_in_group("DoorDecoy")[0].visible = false	
				get_tree().get_nodes_in_group("DoorDecoy")[0].get_children()[0].get_children()[0].disabled = true
		"shrinegatefake":
			if Input.is_action_pressed("interact"):
				pass
		"shrinegate1":
			if Input.is_action_pressed("interact"):
				get_tree().get_nodes_in_group("DoorGate")[0].visible = false
				get_tree().get_nodes_in_group("DoorGate")[0].get_children()[0].get_children()[0].disabled = true
		"shrinegate2":
			if Input.is_action_pressed("interact"):
				get_tree().get_nodes_in_group("DoorGate")[0].visible = false
				get_tree().get_nodes_in_group("DoorGate")[0].get_children()[0].get_children()[0].disabled = true
	
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
		time+=delta;
		if time>flashlight_switch_delay:
			time = 0
			flashlight_switched=false
	
# movement
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	var targetVelocity = Vector2.ZERO
	
	if direction.length() > 1:
		direction = direction.normalized()
		
	if direction.x:
		targetVelocity.x = direction.x * SPEED
	else:
		targetVelocity.x = move_toward(velocity.x, 0, SPEED)

	if direction.y:
		targetVelocity.y = direction.y * SPEED
	else:
		targetVelocity.y = move_toward(velocity.y, 0, SPEED)

	velocity = velocity.lerp(targetVelocity, lerp_strength)
	
	if velocity.length() > 0:
		rotation = -velocity.angle_to(Vector2(1, 0))
		
		
	move_and_slide()
