extends Sprite2D

var time = 0
var readyTalk = false
var interacting = false
var messages_queued = false
var extra_messages = false

var talkedTo = 0
var addedDialogue = 0
var skip_timer = 0
var skip_delay = 1
var message_timer = 0
var message_delay = 4
var messages_left = 0
var current_message = 0

var image1 = Image.load_from_file("res://custom/ArrowOp1.png")
var texture1 = ImageTexture.create_from_image(image1)
var image2 = Image.load_from_file("res://custom/ArrowOp2.png")
var texture2 = ImageTexture.create_from_image(image2)
var image3 = Image.load_from_file("res://custom/ArrowOp3.png")
var texture3 = ImageTexture.create_from_image(image3)
var image4 = Image.load_from_file("res://custom/ArrowOp4.png")
var texture4 = ImageTexture.create_from_image(image4)

var selecting_item = false
var wait_before_select_time = 0

var initial_dialogue = ["You don't belong here, go home.", "Desparate soul aren't you ... fine.", 
"I am the warden of this cursed labyrinth.","I watch too many lost souls lose their lives in these ruins."
,"Put your meaningless ambitions to rest, now leave me alone.","I said leave me alone, not in the mood right now."]

var extra_dialogue = ["What are you on about? Is this a game to you? Figure it out bucko. Hey, the grass here do be lookin a little interesting tho.",
"Yea, the darkness isn't for everyone. Be sure to stay near lanterns and plan your route carefully.",
"Are you sure you aren't on high power mode? Don't keep the light on all the time, only when you need it. If
you run out of power, there are charge conduits in there.","It's said that the direction the wind blows, reveals the location of the shrine, not that you'll find it anyways.",
"If the shrine is activated, for the first time in centuries, the labyrinth will open its doors. Put your meaningless ambitions to rest, now leave me alone.",
"If you collect a certain amount of leaves, doubt you will find even one, it's said that you can earn a powerful shrine's favor. Put your meaningless ambitions to rest, 
now leave me alone."
,"I do know of a few shortcuts in these lands, look for question marks.","You know enough about me, I'm a lonely baboon that mopes all day.",
"Those are relics, I doubt you would put a relic to proper use, but its better than having them sit around. You can have 1 of them."]

var extra_dialogue_headers = ["What are the controls? I don't see them anywhere!",
"Why is it so dark? The darkness makes me go insane ...","My light runs out of power so fast.","What's with the wind?","How can I help?","What are these leaves?"
,"Hidden pathways?","Tell me more about yourself!","What are those items laying beside you?"]

var starter_item_names = ["Efficient Batteries", "Mind Shaping Scroll", "Triforce Talisman", "Deadly Beam Augment"]
var starter_item_descriptions = ["++ Flashlight Efficiency\n -- Max battery.", 
"+++ Insanity Resistance\n -- Max Health",
 "+ All 3 Attributes\n - Insanity Resistance", 
"++ Flashlight Strength\n - Flashlight Efficiency"]

var deaths_help = ["Did you turn on your flashlight? There are different modes you can use. Also, pay special attention to
my announcements I will occasionally broadcast to you.",
"I think you are missing braincells. Sorry, too harsh, did you know you could aim your flashlight? You got some more figuring out to do.", "You are hopeless ..."]
var deaths_help_headers = ["Am I missing anything?","Hi again, is there anything else I'm missing?", "I need more help!"]

var attempts_help = ["Ah yes, those noises are from ghosts lurking in the labyrinth. If you use more powerful
flashlight modes, you will see them.", "There's a top secret passageway around here, look closely. I do recommend
you stay away from it though, a deadly ill omened creature is ahead.", "Told you so bucko, you do not belong here."]
var attempts_help_headers = ["What are those noises?", "I haven't seen any hidden pathways?", "Oops"]

var items_dialogue_left = 1
var death_dialogue_left = 3
var attempts_dialogue_left = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_nodes_in_group("DialogueList")[0].add_item("Nevermind",texture1,true)
	addedDialogue += 1
	
	for x in range(extra_dialogue.size()-1):
		match addedDialogue%4:
			0:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(extra_dialogue_headers[x],texture1,true)
			1:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(extra_dialogue_headers[x],texture2,true)
			2:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(extra_dialogue_headers[x],texture3,true)
			3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(extra_dialogue_headers[x],texture4,true)		
		addedDialogue += 1
		
	for x in range(get_tree().get_nodes_in_group("StarterItemName").size()):
		get_tree().get_nodes_in_group("StarterItemName")[x].text = starter_item_names[x]
	for x in range(get_tree().get_nodes_in_group("StarterItemDescription").size()):
		get_tree().get_nodes_in_group("StarterItemDescription")[x].text = starter_item_descriptions[x]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if time > 1 && readyTalk == false:
		readyTalk = true
	
	if items_dialogue_left == 1 && get_tree().get_nodes_in_group("Player")[0].deaths >= 1 && talkedTo >= 3:
		get_tree().get_nodes_in_group("DialogueList")[0].add_item(extra_dialogue_headers[extra_dialogue.size()-1],texture4,true)
		items_dialogue_left = 0
	
	match death_dialogue_left:
		3:
			if get_tree().get_nodes_in_group("Player")[0].deaths >= 3 && talkedTo >= 3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(deaths_help_headers[death_dialogue_left-1],texture1,true)
				death_dialogue_left -= 1
		2:
			if get_tree().get_nodes_in_group("Player")[0].deaths >= 10 && talkedTo >= 3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(deaths_help_headers[death_dialogue_left-1],texture2,true)
				death_dialogue_left -= 1
		1:
			if get_tree().get_nodes_in_group("Player")[0].deaths >= 25 && talkedTo >= 3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(deaths_help_headers[death_dialogue_left-1],texture3,true)
				death_dialogue_left -= 1
				
	match attempts_dialogue_left:
		3:
			if get_tree().get_nodes_in_group("Player")[0].attempts >= 5 && talkedTo >= 3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(attempts_help_headers[attempts_dialogue_left-1],texture1,true)
				attempts_dialogue_left -= 1
		2:
			if get_tree().get_nodes_in_group("Player")[0].attempts >= 15 && talkedTo >= 3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(attempts_help_headers[attempts_dialogue_left-1],texture1,true)
				attempts_dialogue_left -= 1
		1:
			if get_tree().get_nodes_in_group("Player")[0].attempts >= 50 && talkedTo >= 3:
				get_tree().get_nodes_in_group("DialogueList")[0].add_item(attempts_help_headers[attempts_dialogue_left-1],texture1,true)
				attempts_dialogue_left -= 1

				
	if get_tree().get_nodes_in_group("Player")[0].NPCInteraction == true:
		if Input.is_action_pressed("interact"):
			get_tree().get_nodes_in_group("NPCMessageStatus")[0].visible = false
			interacting = true
			get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
			get_tree().get_nodes_in_group("NPCInterface")[0].visible = true	
			get_tree().get_nodes_in_group("Player")[0].NPCInteraction = false
			skip_timer = 0
			message_timer = 0
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			if talkedTo == 0:
				get_tree().get_nodes_in_group("NPCMessage")[0].visible = true
				get_tree().get_nodes_in_group("NPCMessage")[0].get_child(0).text = initial_dialogue[0]
				talkedTo += 1
			
			elif talkedTo == 1:
				messages_left = 3
				current_message = 1
				get_tree().get_nodes_in_group("NPCMessage")[0].visible = true
				get_tree().get_nodes_in_group("NPCMessage")[0].get_child(0).text = initial_dialogue[1]
				talkedTo += 1
			
			elif talkedTo == 2:
				get_tree().get_nodes_in_group("NPCMessage")[0].visible = true
				get_tree().get_nodes_in_group("NPCMessage")[0].get_child(0).text = initial_dialogue[initial_dialogue.size()-1]
				talkedTo += 1
				
			elif talkedTo >= 3 && get_tree().get_nodes_in_group("Player")[0].attempts >= 2:
				get_tree().get_nodes_in_group("NPCPrompts")[0].visible = true
				extra_messages = true
				talkedTo += 1
				
			elif talkedTo >= 3 && get_tree().get_nodes_in_group("Player")[0].attempts < 2:
				get_tree().get_nodes_in_group("NPCMessage")[0].visible = true
				get_tree().get_nodes_in_group("NPCMessage")[0].get_child(0).text = initial_dialogue[initial_dialogue.size()-1]
				talkedTo += 1
	
	if interacting == true:
		skip_timer += delta
		if skip_timer > skip_delay:
			if Input.is_action_pressed("interact") && message_timer > message_delay/4:
				if messages_queued == true:
					message_timer = message_delay
					skip_timer = 0
				else:
					interacting = false
				extra_messages = false
				
		if messages_left > 0:
			messages_queued = true
		elif messages_left == 0:
			messages_queued = false
			current_message = 0
		if messages_queued:
			message_timer += delta
			if message_timer > message_delay:
				if talkedTo == 2:
					get_tree().get_nodes_in_group("NPCMessage")[0].get_child(0).text = initial_dialogue[1+current_message]
				message_timer = 0
				messages_left -= 1
				current_message += 1
		
		if messages_left == 0 && not selecting_item && not extra_messages:
			message_timer += delta
			if message_timer > message_delay/2:
				get_tree().get_nodes_in_group("NPCMessageStatus")[0].visible = true
			if message_timer > message_delay:
				interacting = false
	
	if selecting_item == true:
		wait_before_select_time += delta
		if wait_before_select_time > message_delay:
			get_tree().get_nodes_in_group("ItemSelect")[0].visible = true
			get_tree().get_nodes_in_group("NPCMessage")[0].visible = false
			get_tree().get_nodes_in_group("NPCPrompts")[0].visible = false
	
	if interacting == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().get_nodes_in_group("NPCInterface")[0].visible = false
		get_tree().get_nodes_in_group("NPCMessage")[0].visible = false
		get_tree().get_nodes_in_group("NPCPrompts")[0].visible = false
		skip_timer = 0


func _on_area_2d_body_entered(body):
	if readyTalk == true:
		if interacting == false && get_tree().get_nodes_in_group("Player")[0] == body:
			get_tree().get_nodes_in_group("Player")[0].NPCInteraction = true
			get_tree().get_nodes_in_group("InteractionInterface")[0].visible = true	
		get_tree().get_nodes_in_group("PlayerInterface")[0].visible = false


func _on_area_2d_body_exited(body):
	if readyTalk == true:
		if get_tree().get_nodes_in_group("Player")[0] == body:
			get_tree().get_nodes_in_group("Player")[0].NPCInteraction = false
			get_tree().get_nodes_in_group("InteractionInterface")[0].visible = false
			get_tree().get_nodes_in_group("Player")[0]
			get_tree().get_nodes_in_group("PlayerInterface")[0].visible = true
			interacting = false
