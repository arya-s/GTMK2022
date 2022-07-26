extends "res://src/Levels/Level.gd"

onready var levels = $EndScreen/Levels.get_children()

func _ready():
	var vals = [1,2,3,4,5,6]
	for i in range(levels.size()):
		var value = levels[i].get_node('Value')
		value.text = 'x' + str(player_stats.get_deaths_for_level(i))
