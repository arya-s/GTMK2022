extends "res://src/Levels/Level.gd"

var game_instances = GameResourceLoader.game_instances
onready var initial_spawn_position = $InitialSpawnPosition


func _ready():
	if State.player_spawn_point == null:
		State.player_spawn_point = initial_spawn_position.global_position
