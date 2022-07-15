extends Node2D

func _ready():
	if State.revealed_secret:
		visible = false
		queue_free()

func _on_Hurtbox_hit(damage, attacker):
	State.revealed_secret = true
	Global.play_secret_reveal_sound()
	queue_free()
