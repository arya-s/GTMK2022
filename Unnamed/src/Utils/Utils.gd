extends Node

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

func change_scene(next):
	get_tree().change_scene(next)

func reset_scene():
	get_tree().reload_current_scene()
