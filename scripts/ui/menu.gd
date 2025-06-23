# Rise of the Dragon King
# 06-23-2025
# Brian Morris

extends Control

# Base Menu
# useful base class for menu interactions. A JRPG is 80% menus, afterall!

class_name Menu

# base menu information
var selected_index := 0

# game objects
@export var options : Array[Node] = []

# menu acceleration logic
var input_direction := 0
var input_timer := 0.0
var input_accel := 0.05 # Speed-up per repeat
const MIN_DELAY := 0.07 # Fastest speed
const MAX_DELAY := 0.35 # Initial delay before repeat
var input_delay := MAX_DELAY

# export variables
@export var selector_icon : Node = null # usually a texture rect
@export var offset := Vector2(-20, 0) # distance from option label

# ready
# called once on startup of the scene
func _ready():
	update_selection()

# process
# called once per frame
func _process(delta):
	# update acceleration information
	if input_direction != 0:
		input_timer += delta
		
		if input_timer >= input_delay:
			move_selector()
			input_timer = 0.0
			input_delay = max(MIN_DELAY, input_delay - input_accel)

# begin selector movement
func begin_selector_movement(direction):
	# skip over calls if movement is still being made
	if input_direction != 0:
		return
	
	input_direction = direction
	input_timer = 0.0
	input_delay = MAX_DELAY
	move_selector()

# end selector movement
func end_selector_movement(direction):
	# skip over calls to the wrong movement direction
	if direction != input_direction:
		return
	
	input_direction = 0

# move left
func move_left():
	# skip over calls if movement is still being made or selection is already min
	if input_direction != 0 or selected_index == 0:
		return
	
	selected_index = 0
	update_selection()

# move right
func move_right():
	# skip over calls if movement is still being made or selection is already max
	if input_direction != 0 or selected_index == options.size() - 1:
		return
	
	selected_index = options.size() - 1
	update_selection()

# move selector
# function to handle selection animation
func move_selector():
	selected_index = (selected_index + input_direction + options.size()) % options.size()
	update_selection()

# update selection
# used to change UI elements to update a new selection
func update_selection():
	if selector_icon and selected_index < options.size():
		var label = options[selected_index]
		selector_icon.global_position = label.global_position + offset

func on_option_selected():
	options[selected_index].on_select()
