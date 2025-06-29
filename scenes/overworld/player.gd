# Rise of the Dragon King
# 06-24-2025
# Brian Morris

extends Node2D

# Player
# the player object on an overworld map

class_name OverworldPlayer

# scene references
@onready var grid_mover : GridMover = $GridMover
@onready var animator : AnimationTree = $AnimationTree
@onready var state_machine = animator.get("parameters/playback")

# control variables
var is_moving := false
var move_dir := Vector2i.ZERO

# external values
var tile_size = 16

# ready
# called once at startup
func _ready():
	animator.set("parameters/Walk/blend_position", Vector2i.DOWN)
	animator.set("parameters/idle/blend_position", Vector2i.DOWN)

# physical process
# is called once per frame of the physics engine
func _physics_process(_delta):
	if is_moving:
		state_machine.travel("Walk")
	else:
		state_machine.travel("idle")
	
	if move_dir != Vector2i.ZERO:
		animator.set("parameters/Walk/blend_position", move_dir)
		animator.set("parameters/idle/blend_position", move_dir)
	
	# only update mover if we're still moving
	if !is_moving:
		return
	
	# mover doesn't need an update if it's still doing its thing
	if grid_mover.target_pos != global_position:
		return
	
	var target_pos = global_position + (Vector2(move_dir) * tile_size)
	
	# test if movement is possible
	if !can_move(target_pos):
		return
	
	# push mover
	grid_mover.move_to(target_pos)

# start move
# begin moving in a direction
func start_move(input_direction : Vector2i):
	is_moving = true
	move_dir = input_direction

# end move
# finish movement
func end_move():
	is_moving = false
	move_dir = Vector2i.ZERO

# can move
# collision test for grid movement
func can_move(target : Vector2):
	return true
