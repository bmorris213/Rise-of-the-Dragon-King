# Rise of the Dragon King
# 06-24-2025
# Brian Morris

extends Node

# Grid Mover
# parses directional input into grid-based movement for an entity on a tilemap

class_name GridMover

# external factors
@export var move_speed := 4	# Tiles per second
@export var parent : Node2D = null

# control variables
@onready var start_pos := parent.global_position
@onready var target_pos := parent.global_position
var movement_progress := 0.0

# physical process
# is called once per frame of the physics engine
func _physics_process(delta):
	if parent.global_position != target_pos:
		movement_progress += delta * move_speed
		if movement_progress >= 1.0:
			parent.global_position = target_pos
		else:
			parent.global_position = start_pos.lerp(target_pos, movement_progress)

# move to
# sets a target and begins motion for the grid mover
func move_to(target : Vector2i):
	if parent.global_position != target_pos:
		return
	start_pos = parent.global_position
	target_pos = target
	movement_progress = 0.0
