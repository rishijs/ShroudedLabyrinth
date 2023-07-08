extends CanvasLayer

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = get_tree().get_current_scene().get_name()


func _process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	match current_scene:
		"Darkness":
			get_tree().get_first_node_in_group("Teaser").text = "These lands are cursed for eternity, thanks to you"
			get_tree().get_first_node_in_group("Thanks").text = "LABYRINTH COMPLETION BRUTALLY FAILED" 
		"Light":
			get_tree().get_first_node_in_group("Teaser").text = "I always knew that you were going to be the one. I have a few connections in neighboring labyrinths, I'll let you know when I have a lead."
			get_tree().get_first_node_in_group("Thanks").text = "THANKS FOR COMPLETING THE SHROUDED LABYRINTH" 
		"Slayer":
			get_tree().get_first_node_in_group("Teaser").text = "You truly are a slayer. Didn't expect strong warrior. I have a few connections in neighboring labyrinths, I'll let you know when I have a lead."
			get_tree().get_first_node_in_group("Thanks").text = "LABYRINTH COMPLETED ON HIGHEST DIFFUCULY" 
		


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
