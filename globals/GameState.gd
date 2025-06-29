# Rise of the Dragon King
# 06-24-2025
# Brian Morris

extends Node

# Game State
# handles global game information regarding a players progress

### temp stuff, for development and testing of global game state
# player stats
var player_hp := 100
var player_mp := 50
var player_level := 1
var player_exp := 0

# player location
var current_region := "Accordia"
var current_scene := "overworld"

# control state for scene delegation
var game_is_paused := false

# inventory
var inventory := {
	"items": [],
	"gold": 100
}

# party
var party := ["Player"]  # Could expand to full actor objects later

# quests
var story_flags := {
	"intro_complete": false,
	"kingdoms_freed": 0
}

# functions for save/load
func save_game():
	print("Saving game... (not implemented)")

func load_game():
	print("Loading game... (not implemented)")

# pause
# used for switching control scheme between menu and player controllers
func pause():
	game_is_paused = not game_is_paused

func _process(_delta):
	SceneLoader.current_scene.active = not game_is_paused
