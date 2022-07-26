extends Node

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1
}

var revealed_secret = false

var starting_level = null
var current_level = null

var ignored_level_transition = null
var level_connection = null



var last_bonfire = null
var last_bonfire_spawn_point = null

var player_spawn_point = null
var player_spawm_facing = DIRECTION.RIGHT
var player_spawn_max_jump = 1

