extends Resource

class_name PlayerStats

export(int) var MAX_HEALTH = 100
export(int) var STARTING_HEALTH = 100
export(int) var MAX_FIREBALLS = 2
export(int) var FIREBALL_COST = 15
export(int) var HEALTH_LOW_THRESHOLD = 8
export(int) var HEALTH_CRITICAL_THRESHOLD = 4

var active_bonfires = {
	'Level_01': false,
	'Level_02': false,
	'Level_03': false,
	'Level_04': false,
	'Level_Oil': false,
	'Level_Furnace': false
}
var health = STARTING_HEALTH setget set_health
var fireballs = 0 setget set_fireballs

signal player_died

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	
	if health == 0:
		emit_signal("player_died")

func set_fireballs(value):
	fireballs = clamp(0, value, MAX_FIREBALLS)
	
func reset_player_stats():
	set_health(STARTING_HEALTH)
	set_fireballs(0)
