extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	visible = false


func _on_reset_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_restart_pressed():
	if get_tree().get_first_node_in_group("Puppet").shrine_interacted == false:
		get_tree().get_first_node_in_group("Player").position = get_tree().get_first_node_in_group("Spawn").global_position

func _on_controls_pressed():
	get_tree().change_scene_to_file("res://scenes/controls.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
