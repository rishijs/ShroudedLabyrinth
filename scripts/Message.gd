extends ColorRect

var messagePending = false
var messageSummary = "default"
var time = 0
var message_display_time = 5

func _ready():
	pass


func _process(delta):
	if messagePending:
		time += delta
		visible = true
		match messageSummary:
			"default":
				get_child(0).get_child(0).text = "Default Message"
			"NoLeaves":
				get_child(0).get_child(0).text = "You're going to need 3 Leaves"
			"ShrineFinal":
				get_child(0).get_child(0).text = "The gateway to your end has opened"
			"DecoyShrine":
				get_child(0).get_child(0).text = "Sometimes, the way forward isn't right in front of you"
			"SpecialShrine":
				get_child(0).get_child(0).text = "Not enough warnings sort"
			"MazeGate":
				get_child(0).get_child(0).text = "Somewhere, a door opens"
			"PuppetDefeated":
				get_child(0).get_child(0).text = "Wow, you actually did it, congrats, I underestimated you"
		if time > message_display_time:
			time = 0
			messagePending = false
			visible = false
			get_child(0).get_child(0).text = "Placeholder Text"
