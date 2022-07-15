extends "res://src/Enemy/Enemy.gd"

enum DIRECTION { 
	LEFT = -1,
	RIGHT = 1
}

export(int) var GRAVITY = 22
export(DIRECTION) var WALKING_DIRECTION 

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var floor_left = $FloorLeft
onready var floor_right = $FloorRight
onready var wall_left = $WallLeft
onready var wall_right = $WallRight

var state = WALKING_DIRECTION

func _ready():
	state = WALKING_DIRECTION
	ALIVE = true
	
func _physics_process(delta):
	motion.y += GRAVITY
	
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not floor_right.is_colliding() or wall_right.is_colliding():
				state = DIRECTION.LEFT

		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not floor_left.is_colliding() or wall_left.is_colliding():
				state = DIRECTION.RIGHT

	sprite.scale.x = sign(motion.x)
	
	if ALIVE:
		motion = move_and_slide(motion, Vector2.UP)

func kill():
	if ALIVE:
		animation_player.play("dying")
		Global.play_rat_dying_sound()
		ALIVE = false

func _on_Hurtbox_hit(damage, attacker):
	kill()
