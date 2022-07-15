extends Area2D

export(int) var damage = 0


func _on_Hitbox_area_entered(hurtbox):	
	var parent = get_node("../")
	# Only emit if the parent is actually
	# alive to fight, dead lingering
	# bodies should not cause damage
	if parent.ALIVE:
		hurtbox.emit_signal("hit", damage, parent)
