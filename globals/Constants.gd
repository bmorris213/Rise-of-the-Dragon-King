# Rise of the Dragon King
# 07-03-2025
# Brian Morris

# Constants
# stores global constant variables for use, change, and project management

class_name Constants

# game management
const RNG_SEED := "G14O15D16O17T180h1a2s3h4H5A6S7H8g9o10d11o12t13"

# control scheme management
const MIN_INTERRUPT_DURATION := 0.1
const MAX_INTERRUPT_DURATION := 180.0
const MENU_ACCELERATION := 0.05 # speed up per repeat
const MENU_MAX_MAX_DELAY := 0.35 # Initial delay before repeat
const MENU_MIN_DELAY := 0.07 # Fastest speed menu selector moves
const MENU_QUIT_DELAY := 3 # how long to hold down the quit before it exits
const QUICK_ACTION_DELAY := 1.2 # how long to animate a quick action event

# scene references
enum SCENE_ID {
	main_menu,
	overworld,
	battle,
	town,
	dungeon,
	control_manager,
	file_manager,
	menu_manager,
	scene_manager,
	audio_manager
}
const SCENES := {
	SCENE_ID.main_menu: "res://scenes/menus/main_menu.tscn",
	SCENE_ID.overworld: "res://scenes/overworld/overworld.tscn",
	SCENE_ID.battle: "res://scenes/battle/battle.tscn",
	SCENE_ID.town: "res://scenes/town/town.tscn",
	SCENE_ID.dungeon: "res://scenes/dungeon/dungeon.tscn",
	SCENE_ID.control_manager: "res://scripts/managers/ControlManager.gd",
	SCENE_ID.file_manager: "res://scripts/managers/FileManager.gd",
	SCENE_ID.menu_manager: "res://scripts/managers/MenuManager.gd",
	SCENE_ID.scene_manager: "res://scripts/managers/SceneManager.gd",
	SCENE_ID.audio_manager: "res://scripts/managers/AudioManager.gd"
}
const INITIAL_SCENE := SCENES[SCENE_ID.overworld] # WIP replace with main menu

# scene node references
const PLAYER_NODE_PATH := "/Player"
const TILES_NODE_PATH := "/Ground Layer"

# menu node references
const SELECTOR_NAME := "Selector"
const OPTION_CONTAINER_NAME := "Options"
const HUD_NAME := "HUD"
const PAUSE_MENU_NAME := "PauseMenu"
const QUICK_MENU_NAME := "QuickMenu"
const DIALOGUE_BOX_NAME := "DialogueBox"
const DIALOGUE_BOX_TITLE_NAME := "Title"
const DIALOGUE_BOX_DESCRIPTION_NAME := "Text"
const TOOLTIP_NAME := "ToolTip"
const QUIT_WARNING_NAME := "QuittingWarning"

# menu control values
const MIN_QUIT_WARNING_OPACITY := 0.4

const TYPING_SPEED := {
	"slow" : 12,
	"medium" : 18,
	"fast" : 24
}
const RAPID_TYPING_MULTIPLIER := 2.75

# overworld information
enum REGIONS {
	Cel,
	Höf,
	Caelor,
	Eldefer,
	Thorazar,
	Moor,
	Missora,
	Indras,
	Alazar,
	Tarak,
	Dagohmor,
	Silvora,
	Telrasi,
	Mokhora,
	Poemas,
	Kililao
}
