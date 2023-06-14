extends Node

var lanterns = [];
var mode = 0; 
var time = 0;

@export var frequency_flicker = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in self.get_children():
		lanterns.append(x.get_child(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > frequency_flicker:
		match mode:
			0:
				for x in lanterns:
					if x.get_meta("light_type") == "outside":
						x.texture_scale = 1.75
					elif x.get_meta("light_type") == "inside":
						x.texture_scale = 0.9
				mode = 1
			1:
				for x in lanterns:
					if x.get_meta("light_type") == "outside":
						x.texture_scale = 1.5
					elif x.get_meta("light_type") == "inside":
						x.texture_scale = 0.75
				mode = 2
			2:
				for x in lanterns:
					if x.get_meta("light_type") == "outside":
						x.texture_scale = 1.75
					elif x.get_meta("light_type") == "inside":
						x.texture_scale = 0.9
				mode = 3
			3:
				for x in lanterns:
					if x.get_meta("light_type") == "outside":
						x.texture_scale = 2
					elif x.get_meta("light_type") == "inside":
						x.texture_scale = 1
				mode = 0
		time = 0
				
	


func _on_area_2d_body_entered(body):
	if get_tree().get_nodes_in_group("Player").size() > 0:
		get_tree().get_nodes_in_group("Player")[0].in_light = true


func _on_area_2d_body_exited(body):
	if get_tree().get_nodes_in_group("Player").size() > 0:
		get_tree().get_nodes_in_group("Player")[0].in_light = false