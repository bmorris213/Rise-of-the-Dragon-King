# Rise of the Dragon King
# 06-23-2025
# Brian Morris

extends Node

# Scene Loader
# moves the user through different scenes

# variables
var container: Node = null
var current_scene: Node = null

# set container
# establishment function
# takes in the target node in main scene for scene management
func set_container(node: Node):
	container = node

# change scene
# main scene changing function
func set_scene(path: String):
	# require a target scene container
	if not container:
		push_error("SceneLoader: container not set!")
		return
	
	# queue active scene
	if current_scene:
		current_scene.queue_free()
	
	# instantiate new scene
	var new_scene = load(path).instantiate()
	container.add_child(new_scene)
	current_scene = new_scene
