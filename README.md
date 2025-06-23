# Rise of the Dragon King
An old school rpg blending FF1, Warriors of the Eternal Sun, Etrian Odyssey, and Shining Force set in the fantasy world of Verumn

# Folder Organization
resources - storing raw media for use in the game - images, audio, and other
data - JSON files for use in game
	maps - metadata on regions, terrains, loot pools, etc for use in overworld, town, and dungeons alike
scenes - storing all window states of the game
	system - the base scenes (main, loading, splash, settings)
scripts - for every programming file not associated directly with other objects
scenes - where gameplay happens
prefabs - reusable templates
UI - easily skin modular windows, menus, layouts, and HUD
globals - persistant, game-wide logic, flags, inventory, etc

# Program Execution

Main
Game startup and management happens within the main.tscn scene, and scene transitions, globals, and other game-wide logic is handled here
	handles Scene Transitions, always the active loaded scene
	allows for persistant UI layers across scene transitions
	allows globals that are always loaded in
	allows for persistant audio management
	misc overlay systems: dialogue, pause menu, tutorials, input prompts

Game State
	auto-load global for managing gamewide stateful information
	contains current scene

Main Menu
	Game manager. Handles storage, deletion, and loading of save files
	access options, extras, credits etc
	new game action
	plays intro scenematic

Save File Manager
	used to save, load, and delete save game files

Overworld
	For the sake of development, this is the "outer most" scene

# Gameplay

# controls
movement: arrow keys (left, right, up, down)
select : z
cancel : x
menu : c
quit : escape (exit program)
