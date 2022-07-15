extends Node2D

onready var sprite = $Sprite
onready var hitbox_collider = $Hitbox/Collider
export(Vector2) var velocity = Vector2.ZERO
var ALIVE = true

func _ready():
	var frame = randi() % sprite.hframes
	sprite.frame = frame
	
	var s = -1 if randf() > 0.5 else 1
	var a = randi() % 4
	var p = Vector2(s * a, 0)
	sprite.position = Vector2(s * a, 0)
	hitbox_collider.position = Vector2(s * a, -8)

func _process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Hitbox_body_entered(body):
	queue_free()

func _on_Hitbox_area_entered(area):
	queue_free()
