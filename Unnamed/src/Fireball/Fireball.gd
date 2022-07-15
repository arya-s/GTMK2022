extends KinematicBody2D

signal fireball_vanished

export(int) var SPEED = 200
export(int) var GRAVITY = 22
export(int) var BOUNCE = -150

onready var bounce_sound = $BounceSound

var motion = Vector2.ZERO
var direction = 1

# hack: not actually used
# we have this property so that checks for enemy ALIVE
# won't fail when the hurtbox enters the hibox
var ALIVE = true


func _ready():
	motion.x = direction * SPEED
	
func _physics_process(delta):
	motion.y += GRAVITY
	
	if is_on_wall():
		vanish()
		return

	if is_on_floor():
		motion.y = BOUNCE
		bounce_sound.play()

	motion = move_and_slide(motion, Vector2.UP)

func vanish():
	emit_signal("fireball_vanished")
	queue_free()
	
func move_in_direction(dir):
	direction = dir
	motion.x = direction * SPEED
	
# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	vanish()


func _on_Hitbox_area_entered(area):
	var parent = area.get_node('..')
	
	if parent.is_in_group('enemy'):
		# Only vanish the fireball if the enemy is still alive
		# decaying enemies are ignored
		if parent.ALIVE:
			vanish()
	else:
		vanish()
