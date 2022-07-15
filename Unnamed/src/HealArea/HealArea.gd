extends Area2D

var game_instances = GameResourceLoader.game_instances

export(int) var HEAL_PER_TICK = 4
export(bool) var ACTIVE = true

onready var tick_timer = $TickTimer

func _on_HealArea_body_entered(body):
	if body.is_in_group("player"):
		tick_timer.start()

func _on_HealArea_body_exited(body):
	if body.is_in_group("player"):
		tick_timer.stop()

func _on_TickTimer_timeout():
	if ACTIVE:
		var player = game_instances.player
		player.heal(HEAL_PER_TICK)
