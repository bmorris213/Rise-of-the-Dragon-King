# Rise of the Dragon King
# 06-29-2025
# Brian Morris

extends Node

# Dialogue Reader
# takes signals for changes to the UI to read out dialogue

# dialogue queue
var dialogue_queue : Array = []
var message_active := false
var is_animating := false
var current_line = null
var buffer : String = ""
var line_index = 0
var typing_speed = TypingSpeed.slow # characters per second
var is_rapid = false
var timer = 0.0

enum TypingSpeed {
	slow = 12,
	medium  = 17,
	fast = 22
}

# UI references
var dialogue_box : MenuManager = null
var title : Label = null
var text : Label = null
var choice_container : Node = null

# set parent
# setup function to grab UI references
func set_parent(root : Node):
	dialogue_box = root
	title = root.get_child(0).get_child(0).get_child(0)
	text = root.get_child(0).get_child(1)
	choice_container = root.get_child(0).get_child(2)
	choice_container.visible = false
	dialogue_box.active = false
	dialogue_box.visible = false

# process
# called once per frame
func _process(delta):
	if not message_active:
		return
	
	if Input.is_action_just_pressed("cancel"):
		is_rapid = true
	
	if Input.is_action_just_released("cancel"):
		is_rapid = false
	
	if Input.is_action_just_pressed("select"):
		show_next_line()
	
	if is_animating == false:
		return
	
	timer += delta * typing_speed
	if (is_rapid):
		timer += delta * typing_speed * 2
	
	if timer < 1:
		return
	
	buffer += current_line.text[line_index]
	line_index += 1
	timer = 0.0
	_update_box()
	_check_for_choices()

# start dialogue
# public api to send messages to the UI
func start_dialogue(dialogue_lines : Array):
	if message_active:
		print("error: dialogue spam")
		return
	
	dialogue_queue = dialogue_lines.duplicate(true)
	message_active = true
	dialogue_box.visible = true
	show_next_line()

# show next line
# progresses the dialogue
func show_next_line():
	if is_animating:
		_finish_line()
		return
	
	if dialogue_queue.is_empty():
		end_dialogue()
		return
	
	if dialogue_box.active:
		clear_options()
	
	current_line = dialogue_queue.pop_front()
	title.text = current_line.name
	
	buffer = ""
	_update_box()
	is_animating = true
	timer = 0.0
	line_index = 0

# function for clearing out current line animation progress
func _finish_line():
	buffer = current_line.text
	is_animating = false
	_update_box()
	_check_for_choices()

# adjusting visual element
func _update_box():
	text.text = buffer

# wrapping up dialogue reading
func end_dialogue():
	dialogue_box.visible = false
	message_active = false
	is_animating = false
	GameState.call_deferred("pause")

# check for choices
# generates choice labels and options, but only if there are choices
func _check_for_choices():
	if line_index >= current_line.text.length():
		is_animating = false
		if not current_line.choices.is_empty():
			dialogue_box.active = true
			choice_container.visible = true
			choice_container.selector_icon.visible = true
			choice_container.set_choices(current_line.choices)
			choice_container.call_deferred("update_selection")

# clear options
# once an option is chosen, the options menu should be emptied
func clear_options():
	choice_container.unset_choices()
	choice_container.selector_icon.visible = false
	choice_container.visible = false
	dialogue_box.active = false
