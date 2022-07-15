extends Node2D

export(int) var speed = 20
onready var animator = $AnimationPlayer
var velocity = Vector2.ZERO

func _ready():
	animator.play("spin")

func _process(delta: float):
	position += velocity * speed * delta

# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


# warning-ignore:unused_argument
func _on_Hitbox_body_entered(body):
	#Utils.instance_scene_on_main(ExplosionEffect, global_position) 
	queue_free()


# warning-ignore:unused_argument
func _on_Hitbox_area_entered(area):
	# remmove when we hit a hurtbox
	#Utils.instance_scene_on_main(ExplosionEffect, global_position) 
	queue_free()
