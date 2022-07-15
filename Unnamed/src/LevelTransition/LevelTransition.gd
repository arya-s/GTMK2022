extends Area2D

export(String, FILE, "*.tscn") var next_level = ""
export(Resource) var connection = null
export(State.DIRECTION) var FACING = State.DIRECTION.LEFT

onready var exit_position = $ExitPosition

var active = true

func _enter_tree():
	active = true

func _on_LevelTransition_body_entered(body):
	if active and body.is_in_group("player"):
		if next_level != "":
			State.ignored_level_transition = self
			State.level_connection = connection
			State.player_spawm_facing = FACING
			Utils.change_scene(next_level)
			active = false
