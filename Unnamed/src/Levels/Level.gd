extends Node

onready var initial_spawn_position = $InitialSpawnPosition

var player_stats = GameResourceLoader.player_stats

export(int) var level = 0

func _ready():
	player_stats.current_level = level
	State.current_level = self.filename
	State.player_spawn_point = initial_spawn_position.global_position
