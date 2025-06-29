# Rise of the Dragon King
# 06-29-2025
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
var moving := false
var move_dir := Vector2i.ZERO
var target_pos := Vector2.ZERO
var previous_terrain := 0
var current_terrain := 0
var region := ""
# region danger skews the random values (0 skews towards large step goals)
var region_danger := 0.2 # 0 < region_danger < 1
var steps := 0
var step_goal := 0

# external values
@onready var tile_size = collision_layer.get("rendering_quadrant_size")

# ready
# called once at startup
func _ready():
	animator.set("parameters/Walk/blend_position", Vector2i.DOWN)
	animator.set("parameters/idle/blend_position", Vector2i.DOWN)
	
	# update terrain we're in
	_update_terrain(global_position)
	_set_step_goal()

# physical process
# is called once per frame of the physics engine
func _physics_process(_delta):
	if moving:
		state_machine.travel("Walk")
	else:
		state_machine.travel("idle")
	
	if move_dir != Vector2i.ZERO:
		animator.set("parameters/Walk/blend_position", move_dir)
		animator.set("parameters/idle/blend_position", move_dir)
	
	# don't do anything until moving again
	if not moving:
		return
	
	# finishing movement
	if grid_mover.target_pos == global_position:
		steps += 1
		print(steps)
		moving = false
		
		# update new terrain
		previous_terrain = current_terrain
		_update_terrain(target_pos)
	
		if previous_terrain != current_terrain:
			_set_step_goal()

# start move
# begin moving in a direction
func start_move(input_direction : Vector2i):
	move_dir = input_direction
	target_pos = global_position + (Vector2(move_dir) * tile_size)
	
	# test if movement is possible
	if !can_move(target_pos):
		return
	
	moving = true
	grid_mover.move_to(target_pos)

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

# random combat feature
func _set_step_goal():
	# WIP
	# set terrain danger
	var min_steps := 0
	var max_steps := 0
	match(current_terrain):
		-1: # plains
			min_steps = 10
			max_steps = 20
		0: # roads
			min_steps = 20
			max_steps = 40
		1: # tier 3 danger
			min_steps = 9
			max_steps = 18
		2: # tier 2 danger
			min_steps = 6
			max_steps = 12
		3: # tier 1 danger
			min_steps = 3
			max_steps = 6
	
	# randomize step goal
	var randomValue = randf()
	var skewed_value = pow(randomValue, region_danger)
	step_goal = round(lerp(min_steps, max_steps, skewed_value))

# interaction feature
func get_location() -> Vector2i:
	return collision_layer.local_to_map(global_position)
