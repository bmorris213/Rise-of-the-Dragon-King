# Rise of the Dragon King
# 06-23-2025
# Brian Morris

extends Node2D

# main
# the code execution entry point for the game
# sets up main.tscn and opens the game

# ready
# called once on startup of the scene
# code execution entry
func _ready():
	# load in the first scene
	SceneLoader.set_container($ActiveScene)
	SceneLoader.set_scene("res://scenes/system/main_menu.tscn") # replace with res://scenes/system/main_menu.tscn
