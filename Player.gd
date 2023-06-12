extends CharacterBody2D

const SPEED = 300.0
var shrines
var shrine_type = "default"

@export var direction:String

# ready
func _ready():
	shrines = get_tree().get_nodes_in_group("shrine")
	
	if  RandomNumberGenerator.new().randi_range(0,1) == 0:
		direction = "left"
	else:
		direction = "right"
	
# tick
func _process(delta):
	
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
	
# movement
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	if direction.length() > 1:
		direction = direction.normalized()

	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction.y:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.length() > 0:
		rotation = -velocity.angle_to(Vector2(1, 0))
		
		
	move_and_slide()
