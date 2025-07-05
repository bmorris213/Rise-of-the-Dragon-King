# Rise of the Dragon King
# 07-05-2025
# Brian Morris

extends Node

# Control Manager
# from the main scene, handles all user input in the game

class_name ControlManager

# control variables
var _input_locked := false
var _quit_timer := 0.0
var _trying_to_quit := false
var _viewing_menu := false

# menu control details
var _menu_direction := Vector2i.ZERO
var _menu_timer := 0.0
var _menu_delay := Constants.MENU_MAX_MAX_DELAY

# active control details
var _last_direction := Vector2i.ZERO
var _action_buffer := ""
var _player_is_moving := false
var _quick_key_active := false
var _quick_key_lock := false # distinguish between a toggle and hold of quick key menu

# process
# called once per frame
func process(delta : float):
	# update acceleration information
	if _menu_direction != Vector2i.ZERO:
		_menu_timer += delta
		
		if _menu_timer >= _menu_delay:
			GameManager.menu_manager.move_selector(_menu_direction)
			_menu_timer = 0.0
			_menu_delay = max(Constants.MENU_MIN_DELAY, _menu_delay - Constants.MENU_ACCELERATION)
	
	# update quit timer
	if _trying_to_quit:
		# progress timer
		_quit_timer += delta
		GameManager.menu_manager.signal_quitting(_quit_timer / Constants.MENU_QUIT_DELAY)
		
		if _quit_timer >= Constants.MENU_QUIT_DELAY:
			GameManager.get_tree().quit() # exit game completely

# handle input
# main control delegation loop
func handle_input():
	# accommodate input lock
	if _input_locked:
		return
	
	# check for quit action start and end
	if _trying_to_quit:
		if not Input.is_action_pressed("quit"):
			_trying_to_quit = false
			GameManager.menu_manager.signal_quitting(-1.0)
			_quit_timer = 0.0
	elif Input.is_action_pressed("quit"):
		_trying_to_quit = true
		_quit_timer = 0.0
	
	# delegate to quick key menu
	if _quick_key_active:
		# update changing selection
		var quick_key_choice = Vector2i.ZERO
		if Input.is_action_pressed("up"):
			quick_key_choice = Vector2i.UP
		elif Input.is_action_pressed("down"):
			quick_key_choice = Vector2i.DOWN
		elif Input.is_action_pressed("left"):
			quick_key_choice = Vector2i.LEFT
		elif Input.is_action_pressed("right"):
			quick_key_choice = Vector2i.RIGHT
		GameManager.menu_manager.highlight_quick_key(quick_key_choice)
		
		# activate quick key option
		if Input.is_action_just_pressed("select"):
			var selected_action = GameManager.get_quick_action(quick_key_choice)
			GameManager.menu_manager.close_menus()
			GameManager.scene_manager.call_action(selected_action)
			_quick_key_active = false
			_quick_key_lock = false
			pause(Constants.QUICK_ACTION_DELAY)
		return
	
	# delegate to menu controls
	if _viewing_menu:
		# speed while speaking
		if GameManager.menu_manager.is_speaking():
			if Input.is_action_pressed("cancel"):
				GameManager.menu_manager.rapid = true
			else:
				GameManager.menu_manager.rapid = false
		else:
			if Input.is_action_just_pressed("cancel"):
				GameManager.menu_manager.cancel()
		
		if Input.is_action_just_pressed("select"):
			GameManager.menu_manager.select()
		elif Input.is_action_just_pressed("menu"):
			pause()
			GameManager.menu_manager.close_menus()
		else:
			_handle_menu_movement()
		return
	
	# buffer actions until movement ends
	if _player_is_moving:
		if Input.is_action_just_pressed("select"):
			_action_buffer = "select"
		elif Input.is_action_just_pressed("menu"):
			_action_buffer = "menu"
		return
	
	# check for opening and closing quick key menu
	if _quick_key_active:
		if _quick_key_lock:
			if Input.is_action_pressed("cancel"):
				_quick_key_lock = false
				return
		else:
			if Input.is_action_just_released("cancel"):
				_quick_key_active = false
				GameManager.menu_manager.close_menus()
				pause()
				return
	elif Input.is_action_just_pressed("cancel"):
		_quick_key_active = true
		_quick_key_lock = true
		pause()
		GameManager.menu_manager.open_menu(MenuManager.Menus.quick_menu)
		return
	
	# check for a stored action buffer
	if _action_buffer != "":
		match(_action_buffer):
			"select":
				GameManager.scene_manager.try_select()
				_action_buffer = ""
				return
			"menu":
				pause()
				GameManager.menu_manager.open_menu(MenuManager.Menus.pause_menu)
				return
	
	# start a move or an action
	if Input.is_action_just_pressed("select"):
		GameManager.scene_manager.try_select()
	elif Input.is_action_just_pressed("menu"):
		pause()
		GameManager.menu_manager.open_menu(MenuManager.Menus.pause_menu)
	elif Input.is_action_pressed("up"):
		_last_direction = Vector2i.UP
		_player_is_moving = GameManager.scene_manager.move_player(_last_direction)
	elif Input.is_action_pressed("down"):
		_last_direction = Vector2i.DOWN
		_player_is_moving = GameManager.scene_manager.move_player(_last_direction)
	elif Input.is_action_pressed("left"):
		_last_direction = Vector2i.LEFT
		_player_is_moving = GameManager.scene_manager.move_player(_last_direction)
	elif Input.is_action_pressed("right"):
		_last_direction = Vector2i.RIGHT
		_player_is_moving = GameManager.scene_manager.move_player(_last_direction)

# will continue move
# called once the mover stops at a new tile
func will_continue_move() -> bool:
	# once movement stops, detect if we want it to continue
	if (Input.is_action_pressed("up") and _last_direction == Vector2i.UP) or\
	(Input.is_action_pressed("down") and _last_direction == Vector2i.DOWN) or\
	(Input.is_action_pressed("left") and _last_direction == Vector2i.LEFT) or\
	(Input.is_action_pressed("right") and _last_direction == Vector2i.RIGHT):
		# clear buffer and move
		_action_buffer = ""
		_player_is_moving = GameManager.scene_manager.move_player(_last_direction)
		return true
	
	 # movement has ended
	_player_is_moving = false
	
	return false

# pause
# switches between active and menu control mode
func pause(duration : float = Constants.MIN_INTERRUPT_DURATION):
	# clear data
	_last_direction = Vector2i.ZERO
	_action_buffer = ""
	
	# cause a gameplay interrupt
	interrupt(duration)
	
	# switch to the opposite of the current control mode
	_viewing_menu = not _viewing_menu
	
	# disable quick key menu when pausing
	if _viewing_menu and _quick_key_active:
		_quick_key_active = false
		_quick_key_lock = false
		GameManager.menu_manager.close_menus()

# interrupt
# temporarily disables controls globally during a transition
func interrupt(duration : float = Constants.MIN_INTERRUPT_DURATION):
	# error check duration value
	if duration <= 0:
		push_error("ControlManager: interrupt called for <= 0 duration")
		return
	
	# enforce minimum and maximum durations
	if duration < Constants.MIN_INTERRUPT_DURATION:
		duration = Constants.MIN_INTERRUPT_DURATION
	elif duration > Constants.MAX_INTERRUPT_DURATION:
		duration = Constants.MAX_INTERRUPT_DURATION
	
	# disable controls
	_input_locked = true
	
	# wait the specified duration
	await GameManager.get_tree().create_timer(duration).timeout
	
	# re-enable controls globally after a transition
	_input_locked = false

# handle menu movement
# while the user is holding down a movement key, speed up selection calls
func _handle_menu_movement():
	# check for an end to selector movement
	match(_menu_direction):
		Vector2i.UP:
			if Input.is_action_just_released("up"):
				_end_menu_move()
		Vector2i.DOWN:
			if Input.is_action_just_released("down"):
				_end_menu_move()
		Vector2i.RIGHT:
			if Input.is_action_just_released("right"):
				_end_menu_move()
		Vector2i.LEFT:
			if Input.is_action_just_released("left"):
				_end_menu_move()
	
	# check if we're still moving but need to stop
	if _menu_direction != Vector2i.ZERO:
		if not Input.is_anything_pressed():
			_end_menu_move()
			return
	
	# check for the beginning of a new movement
	if Input.is_action_just_pressed("up"):
		_start_menu_move(Vector2i.UP)
	elif Input.is_action_just_pressed("down"):
		_start_menu_move(Vector2i.DOWN)
	elif Input.is_action_just_pressed("left"):
		_start_menu_move(Vector2i.LEFT)
	elif Input.is_action_just_pressed("right"):
		_start_menu_move(Vector2i.RIGHT)
	

# starts a movement of the selector for the menu
func _start_menu_move(new_direction : Vector2i):
	_menu_direction = new_direction
	GameManager.menu_manager.move_selector(_menu_direction)
	_menu_timer = 0.0
	_menu_delay = Constants.MENU_MAX_MAX_DELAY

# stops a movement of the selector for the menu
func _end_menu_move():
	_menu_direction = Vector2i.ZERO
	_menu_timer = 0.0
	_menu_delay = Constants.MENU_MAX_MAX_DELAY
