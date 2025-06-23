# Rise of the Dragon King
# 06-23-2025
# Brian Morris

extends Control

# Base Menu
# useful base class for menu interactions. A JRPG is 80% menus, afterall!

class_name BaseMenu

# base menu information
var selected_index := 0
var options := []

# game objects
var option_labels := [] # node objects for visual feedback
var selector_icon : Node = null

# menu acceleration logic
var input_direction := 0
var input_timer := 0.0
var input_accel := 0.05 # Speed-up per repeat
var input_min_delay := 0.07 # Fastest speed
var input_hold_timer := 0.0
const INPUT_DELAY := 0.35 # Initial delay before repeat
var input_delay := INPUT_DELAY

# export variables
@export var selector_path := "Selector" # usually a texture rect
@export var offset := Vector2(-20, 0) # distance from option label

# ready
# called once on startup of the scene
func _ready():
	selector_icon = get_node(selector_path) # reference this menu's selector
	update_selection()

# update selection
# used to change UI elements to update a new selection
func update_selection():
	if selector_icon and selected_index < option_labels.size():
		var label = option_labels[selected_index]
		selector_icon.global_position = label.global_position + offset

# process
# called once per frame
func _process(delta):
	if input_direction != 0:
		input_hold_timer += delta
		input_timer -= delta
		
		if input_timer <= 0:
			move_selector()
			input_delay = max(input_min_delay, input_delay - input_accel)
			input_timer = input_delay

# unhandled input
# handles any otherwise unhandled control input events
func _unhandled_input(event):
	if event.is_action_pressed("down"):
		if input_direction != 0:
			return
		input_direction = 1
		input_timer = 0
		input_delay = INPUT_DELAY
		move_selector()
	elif event.is_action_released("down") or event.is_action_released("up"):
		input_direction = 0
		input_timer = 0
		input_hold_timer = 0
		input_delay = INPUT_DELAY
	elif event.is_action_pressed("up"):
		if input_direction != 0:
			return
		input_direction = -1
		input_timer = 0
		input_delay = INPUT_DELAY
		move_selector()
	elif event.is_action_released("left"):
		if input_direction != 0:
			return
		selected_index = 0
		update_selection()
	elif event.is_action_released("right"):
		if input_direction != 0:
			return
		selected_index = options.size() - 1
		update_selection()
	elif event.is_action_pressed("select"):
		on_option_selected()
	elif event.is_action_pressed("cancel"):
		on_cancel()

# move selector
# function to handle selection animation
func move_selector():
	selected_index = (selected_index + input_direction + options.size()) % options.size()
	update_selection()

func on_option_selected():
	# Override this in child menu scenes
	pass

func on_cancel():
	# Override this for cancel behavior
	pass
