extends Node

var game_instances = GameResourceLoader.game_instances

export(String, FILE, "Level_*.tscn") var starting_level

onready var current_level = starting_level

func _ready():
	VisualServer.set_default_clear_color(Color('d5cb55'))
	State.starting_level = starting_level
	Utils.change_scene(starting_level)
