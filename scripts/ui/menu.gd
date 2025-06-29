# Rise of the Dragon King
# 06-29-2025
# Brian Morris

extends Control

# Base Menu
# useful base class for menu interactions. A JRPG is 80% menus, afterall!

class_name Menu

# base menu information
var selected_index := 0

# game objects
@export var options : Array[Node] = []
var option_functions : Dictionary

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
	call_deferred("update_selection")

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
func move_to_start():
	# skip over calls if movement is still being made or selection is already min
	if input_direction != 0 or selected_index == 0:
		return
	
	selected_index = 0
	update_selection()

# move right
func move_to_end():
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
		selector_icon.global_position = options[selected_index].global_position + offset

# set choices
# used to generate choice scripts and attach them to the options
func set_choices(choices : Array):
	options = []
	for choice in choices:
		_create_option(choice)

# create option
# makes a new label option using choice information
func _create_option(choice : Dictionary):
	var label = Label.new()
	
	label.set("size_flags_horizontal", 2)
	label.set("custom_minimum_size", Vector2(100, 0))
	label.set("vertical_alignment", 1)
	label.set("horizontal_alignment", 1)
	var label_settings = load("res://assets/fonts/label_font.tres")
	label.set("label_settings", label_settings)
	
	label.text = choice.text
	
	option_functions[label.text] = choice.function
	
	add_child(label)
	options.append(label)

# unset choices
# once an option is made, we need to clear out the data
func unset_choices():
	for option in options:
		option.free()
	options = []
	option_functions = {}

func on_option_selected():
	var function = option_functions[options[selected_index].text]
	if function and function is Callable and function.is_valid():
		function.call()
