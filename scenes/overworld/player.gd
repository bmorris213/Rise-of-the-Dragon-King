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
@export var collision_layer : TileMapLayer = null
@export var terrain_layer : TileMapLayer = null

# control variables
var is_moving := false
var move_dir := Vector2i.ZERO
var current_terrain := 0

# external values
@onready var tile_size = collision_layer.get("rendering_quadrant_size")

# ready
# called once at startup
func _ready():
	animator.set("parameters/Walk/blend_position", Vector2i.DOWN)
	animator.set("parameters/idle/blend_position", Vector2i.DOWN)
	
	# update terrain we're in
	_update_terrain(global_position)

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
	
	# update eventual terrain
	_update_terrain(target_pos)
	
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
	var grid_location = collision_layer.local_to_map(target)
	return collision_layer.get_cell_source_id(grid_location) == -1

# update terrain
# check for a tile under our feet and detect terrain info
func _update_terrain(target):
	var grid_location = terrain_layer.local_to_map(target)
	var data = terrain_layer.get_cell_alternative_tile(grid_location)
	
	current_terrain = data
