extends CanvasLayer

var warning1 = false;
var warning2 = false;
var warning3 = false;
var warning1CD = false;
var warning2CD = false;
var warning3CD = false;
var warning_display_time = 3;
var time1 = 0
var time2 = 0
var time3 = 0
var warning_cooldown = 10;

var time_mins = 0
var time_hours = 0
var time_seconds = 0
var time_base = 0

var image1 = Image.load_from_file("res://custom/Efficient_Batteries.png")
var texture1 = ImageTexture.create_from_image(image1)
var image2 = Image.load_from_file("res://custom/Mind_Shaping_Scroll.png")
var texture2 = ImageTexture.create_from_image(image2)
var image3 = Image.load_from_file("res://custom/Triforce_Technique.png")
var texture3 = ImageTexture.create_from_image(image3)
var image4 = Image.load_from_file("res://custom/Deadly_Beams.png")
var texture4 = ImageTexture.create_from_image(image4)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	time_base += delta
	if time_base >= 1:
		time_seconds += 1
		time_base = 0
	if time_seconds >= 60:
		time_mins += 1
		time_seconds = 0
	if time_mins >= 60:
		time_hours += 1
		time_mins = 0
	
	if time_hours < 10 && time_mins < 10 && time_seconds < 10:
		get_tree().get_first_node_in_group("TimerUI").text = "0"+str(time_hours) +":0"+ str(time_mins)+":0"+str(time_seconds)
	elif time_hours < 10 && time_mins < 10:
		get_tree().get_first_node_in_group("TimerUI").text = "0"+str(time_hours) +":0"+ str(time_mins)+":"+str(time_seconds)
	elif time_hours < 10:
		get_tree().get_first_node_in_group("TimerUI").text = "0"+str(time_hours) +":"+ str(time_mins)+":"+str(time_seconds)
	elif time_mins < 10 && time_seconds < 10:
		get_tree().get_first_node_in_group("TimerUI").text = str(time_hours) +":0"+ str(time_mins)+":0"+str(time_seconds)
	elif time_seconds < 10:
		get_tree().get_first_node_in_group("TimerUI").text = str(time_hours) +":"+ str(time_mins)+":0"+str(time_seconds)
	elif time_mins < 10:
		get_tree().get_first_node_in_group("TimerUI").text = str(time_hours) +":0"+ str(time_mins)+":"+str(time_seconds)
		
		
	get_tree().get_first_node_in_group("DeathUI").text = str(get_tree().get_first_node_in_group("Player").deaths) +" DEATH(S)"
		
	if get_tree().get_first_node_in_group("Player").item_equipped == -1:
		get_tree().get_first_node_in_group("ItemEquppedIcon").get_parent().visible = false
	else:
		match get_tree().get_first_node_in_group("Player").item_equipped:
			1:
				get_tree().get_first_node_in_group("ItemEquppedIcon").texture = texture1
			2:
				get_tree().get_first_node_in_group("ItemEquppedIcon").texture = texture2
			3:
				get_tree().get_first_node_in_group("ItemEquppedIcon").texture = texture3
			4:
				get_tree().get_first_node_in_group("ItemEquppedIcon").texture = texture4
		get_tree().get_first_node_in_group("ItemEquppedIcon").get_parent().visible = true
		
	if warning1 || warning1CD:
		time1 += delta
		if time1 > warning_display_time && warning1 == true:
			time1 = 0
			warning1 = false
			get_tree().get_first_node_in_group("warning1").visible = false
		if time1 > warning_cooldown && warning1CD == true:
			warning1CD = false
			time1 = 0
						
	if warning2 || warning2CD:
		time2 += delta
		if time2 > warning_display_time && warning2 == true:
			time2 = 0
			warning2 = false
			get_tree().get_first_node_in_group("warning2").visible = false
		if time2 > warning_cooldown && warning2CD == true:
			warning2CD = false
			time2 = 0
			
	if warning3 || warning3CD:
		time3 += delta
		if time3 > warning_display_time && warning3 == true:
			time3 = 0
			warning3 = false
			get_tree().get_first_node_in_group("warning3").visible = false
		if time3 > warning_cooldown && warning3CD == true:
			warning3CD = false
			time3 = 0
	
	if warning1:
		get_tree().get_first_node_in_group("warning1").visible = true
	if warning2:
		get_tree().get_first_node_in_group("warning2").visible = true
	if warning3:
		get_tree().get_first_node_in_group("warning3").visible = true
		
		
	match get_tree().get_first_node_in_group("Player").leaves_collected:
		0:
			get_tree().get_first_node_in_group("leaf1text").visible = false
			get_tree().get_first_node_in_group("leaf2text").visible = false
			get_tree().get_first_node_in_group("leaf3text").visible = false
		1:
			get_tree().get_first_node_in_group("leaf1text").visible = true
			get_tree().get_first_node_in_group("leaf2text").visible = false
			get_tree().get_first_node_in_group("leaf3text").visible = false
		2:
			get_tree().get_first_node_in_group("leaf1text").visible = true
			get_tree().get_first_node_in_group("leaf2text").visible = true
			get_tree().get_first_node_in_group("leaf3text").visible = false
		3:
			get_tree().get_first_node_in_group("leaf1text").visible = true
			get_tree().get_first_node_in_group("leaf2text").visible = true
			get_tree().get_first_node_in_group("leaf3text").visible = true
	
	if get_tree().get_nodes_in_group("Player")[0].battery < get_tree().get_nodes_in_group("Player")[0].low_battery_threshold:
		if warning3CD == false:
			warning3 = true
			warning3CD = true
		
	if get_tree().get_nodes_in_group("Player")[0].insanity > get_tree().get_nodes_in_group("Player")[0].insanity_threshold:
		if warning2CD == false:
			warning2 = true
			warning2CD = true
		
	if get_tree().get_nodes_in_group("Player")[0].health < get_tree().get_nodes_in_group("Player")[0].low_health_threshold:
		if warning1CD == false:	
			warning1 = true
			warning1CD = true
