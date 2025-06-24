# Rise of the Dragon King
# 06-23-2025
# Brian Morris

extends Node2D

# overworld
# basic overworld control script

@onready var player : OverworldPlayer = $Player

var buffer := Vector2i.ZERO
var direction := Vector2i.ZERO

# process
# runs once per frame
func _process(_delta):
	# check for an end to movement
	if Input.is_action_just_released("up"):
		if player.is_moving:
			if direction == Vector2i.UP:
				player.end_move()
				if buffer != Vector2i.ZERO:
					player.start_move(buffer)
					buffer = Vector2i.ZERO
	elif Input.is_action_just_released("down"):
		if player.is_moving:
			if direction == Vector2i.DOWN:
				player.end_move()
				if buffer != Vector2i.ZERO:
					player.start_move(buffer)
					buffer = Vector2i.ZERO
	elif Input.is_action_just_released("left"):
		if player.is_moving:
			if direction == Vector2i.LEFT:
				player.end_move()
				if buffer != Vector2i.ZERO:
					player.start_move(buffer)
					buffer = Vector2i.ZERO
	elif Input.is_action_just_released("right"):
		if player.is_moving:
			if direction == Vector2i.RIGHT:
				player.end_move()
				if buffer != Vector2i.ZERO:
					player.start_move(buffer)
					buffer = Vector2i.ZERO
	
	# check for movement input
	if Input.is_action_pressed("up"):
		if player.is_moving:
			buffer = Vector2i.UP
		else:
			direction = Vector2i.UP
			player.start_move(direction)
	elif Input.is_action_pressed("down"):
		if player.is_moving:
			buffer = Vector2i.DOWN
		else:
			direction = Vector2i.DOWN
			player.start_move(direction)
	elif Input.is_action_pressed("left"):
		if player.is_moving:
			buffer = Vector2i.LEFT
		else:
			direction = Vector2i.LEFT
			player.start_move(direction)
	elif Input.is_action_pressed("right"):
		if player.is_moving:
			buffer = Vector2i.RIGHT
		else:
			direction = Vector2i.RIGHT
			player.start_move(direction)
	
	buffer = Vector2i.ZERO
