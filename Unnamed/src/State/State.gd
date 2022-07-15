extends Node

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1
}

var revealed_secret = false

var starting_level = null

var ignored_level_transition = null
var level_connection = null



var last_bonfire = null
var last_bonfire_spawn_point = null

var player_spawn_point = null
var player_spawm_facing = DIRECTION.RIGHT

var bonfires = {
	'Level_01': {
		level = "res://src/Levels/Level_01.tscn",
		active = false,
		bonfire = null
	},
	'Level_02': {
		level = "res://src/Levels/Level_02.tscn",
		active = false,
		bonfire = null
	},
	'Level_03': {
		level = "res://src/Levels/Level_03.tscn",
		active = false,
		bonfire = null
	},
	'Level_04': {
		level = "res://src/Levels/Level_04.tscn",
		active = false,
		bonfire = null
	},
	'Level_05': {
		level = "res://src/Levels/Level_05.tscn",
		active = false,
		bonfire = null
	},
	'Level_Oil': {
		level = "res://src/Levels/Level_Oil.tscn",
		active = false,
		bonfire = null
	},
	'Level_Furnace': {
		level = "res://src/Levels/Level_Furnace.tscn",
		active = false,
		bonfire = null
	},
}
