# Rise of the Dragon King
# 06-29-2025
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
	SceneLoader.set_scene(Constants.OVERWORLD_SCENE_PATH) # replace with main menu
	
	# set up dialogue reader
	DialogueReader.set_parent($GlobalUI/Hud/CanvasLayer/DialogueBox)
