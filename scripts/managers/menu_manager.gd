# Rise of the Dragon King
# 06-29-2025
# Brian Morris

extends Node

# Menu Manager
# handles all nesting menu navigation within a given UI scene

class_name MenuManager

# stack of all nesting menus accessed
var menu_stack := []

# main control variable for accepting input
var active := false

# default first menu
@export var base_menu : Menu = null

# ready
# called once on startup of the scene
func _ready():
	menu_stack.append(base_menu)
	base_menu.grab_focus()

# unhandled input
# handle UI input
func _unhandled_input(event):
	if not active:
		return
	
	if event.is_action_released("left"):
		menu_stack[-1].move_left()
	elif event.is_action_released("right"):
		menu_stack[-1].move_right()
	elif event.is_action_pressed("up"):
		menu_stack[-1].begin_selector_movement(-1)
	elif event.is_action_pressed("down"):
		menu_stack[-1].begin_selector_movement(1)
	elif event.is_action_released("up"):
		menu_stack[-1].end_selector_movement(-1)
	elif event.is_action_released("down"):
		menu_stack[-1].end_selector_movement(1)
	elif event.is_action_released("select"):
		menu_stack[-1].on_option_selected()
	elif event.is_action_released("cancel"):
		back()
	elif event.is_action_released("menu"):
		exit()

# open menu
# open a sub menu and add it to the stack
func open_menu(new_menu : Menu):
	menu_stack.append(new_menu)
	new_menu.visible = true
	new_menu.grab_focus()

# back
# close a menu and reenable the previous one, or exit menu scene entirely
func back():
	print("back")

# exit
# back completely out of a menu heirarchy
func exit():
	print("exit")
