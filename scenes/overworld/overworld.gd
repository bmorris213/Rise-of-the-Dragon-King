# Rise of the Dragon King
# 06-29-2025
# Brian Morris

extends Node2D

# overworld
# basic overworld control script

@onready var player : OverworldPlayer = $Player

var buffer := []
var direction := Vector2i.ZERO
var active := true
var action_buffer := ""

# test locations
var locations = {
	Vector2i(14,10): {
		"name": "Town 1",
		"description": "You approach the small village in the hills",
		"on_enter": func(): change_scene("Town 1", "You enter the tutorial town...")
	},
	Vector2i(20,20): {
		"name": "Forest Dungeon",
		"description": "You find a temple in the woods.",
		"on_enter": func(): change_scene("Forest Dungeon", "You enter the forest dungeon...")
	},
	Vector2i(25,15): {
		"name": "Mountain Dungeon",
		"description": "After a long journey, you find a temple in the mountains.",
		"on_enter": func(): change_scene("Mountain Dungeon", "You enter the Mountain Dungeon...")
	},
	Vector2i(28, 10): {
		"name": "Town 2",
		"description": "You approach the walled town against the cliffside.",
		"on_enter": func(): change_scene("Town 2", "You enter the second town...")
	},
	Vector2i(35, 9): {
		"name": "Far Town",
		"description": "How did you get here? This shouldn't exist.",
		"on_enter": func(): change_scene("Far Town", "Sorry, but this doesn't exist...")
	},
	Vector2i(12, 16): {
		"name": "Secret Location",
		"description": "After wandering the forest, you stumble into a quaint grove.",
		"on_enter": func(): change_scene("Secret Location", "You enter the clearing in the woods...")
	}
}

# process
# runs once per frame
func _physics_process(_delta):
	if not active:
		return
	
	if player.steps >= player.step_goal:
		player._set_step_goal()
		player.steps = 0
		begin_battle()
		return
	
	_act_on_buffers()
	_handle_user_input()

# checks for key press events
func _handle_user_input():
	# check for interaction keys
	if Input.is_action_just_pressed("select"):
		if not player.moving:
			try_select()
			return
		else:
			action_buffer = "select"
	elif Input.is_action_just_pressed("cancel"):
		if not player.moving:
			try_cancel()
			return
		else:
			action_buffer = "cancel"
	elif Input.is_action_just_pressed("menu"):
		if not player.moving:
			try_menu()
			return
		else:
			action_buffer = "menu"
	
	# check for movement input
	if Input.is_action_pressed("up"):
		if player.moving:
			if direction != Vector2i.UP:
				buffer.append(Vector2i.UP)
		else:
			direction = Vector2i.UP
			player.start_move(direction)
	elif Input.is_action_pressed("down"):
		if player.moving:
			if direction != Vector2i.DOWN:
				buffer.append(Vector2i.DOWN)
		else:
			direction = Vector2i.DOWN
			player.start_move(direction)
	elif Input.is_action_pressed("left"):
		if player.moving:
			if direction != Vector2i.LEFT:
				buffer.append(Vector2i.LEFT)
		else:
			direction = Vector2i.LEFT
			player.start_move(direction)
	elif Input.is_action_pressed("right"):
		if player.moving:
			if direction != Vector2i.RIGHT:
				buffer.append(Vector2i.RIGHT)
		else:
			direction = Vector2i.RIGHT
			player.start_move(direction)

# if input has been buffered, handle them
func _act_on_buffers():
	if buffer != []:
		if not player.moving:
			for i in range(buffer.size()):
				var buffered_input = buffer.pop_front()
				player.start_move(buffered_input)
				direction = buffered_input
			return
	
	if action_buffer != "":
		if not player.moving:
			match(action_buffer):
				"select":
					try_select()
				"cancel":
					try_cancel()
				"menu":
					try_menu()
			action_buffer = ""

func try_select():
	action_buffer = ""
	var target = player.get_location()
	if target not in locations:
		var lines = [{"name": "Searching", "text": "You find nothing of note here...", "choices": []}]
		DialogueReader.call_deferred("start_dialogue", lines)
		return
	
	var location = locations[target]
	var new_line := { "name": location.name, "text": location.description, "choices": [
		{"text": "Leave", "function": func(): pass},
		{"text": "Enter", "function": location.on_enter}
	]}
	DialogueReader.start_dialogue([new_line])

func try_cancel():
	action_buffer = ""
	print('open scope?')

func try_menu():
	action_buffer = ""
	print('opens menu')

func change_scene(location_name: String, transition: String):
	var lines = [{"name": location_name, "text": transition, "choices": []}]
	player.steps = 0
	DialogueReader.call_deferred("start_dialogue", lines)

func begin_battle():
	var lines = [{"name": "Battle Start", "text": "An enemy appears!", "choices": []}]
	DialogueReader.call_deferred("start_dialogue", lines)
