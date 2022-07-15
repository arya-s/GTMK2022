extends KinematicBody2D

enum DIRECTION { 
	LEFT = -1,
	RIGHT = 1	
}

export(int) var health = 13

export(int) var GRAVITY = 22
export(DIRECTION) var WALKING_DIRECTION
export(int) var MAX_SPEED = 80
export(bool) var ALIVE = true

var motion = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var floor_left = $FloorLeft
onready var floor_right = $FloorRight
onready var wall_left = $WallLeft
onready var wall_right = $WallRight
onready var start_fight_timer = $StartFightTimer


enum STATES {
	IDLE = 0,
	RUNNING = 1,
}

var running_state = WALKING_DIRECTION
var state = STATES.IDLE

signal boss_died

func _ready():
	running_state = WALKING_DIRECTION
	ALIVE = true

func _physics_process(delta):	
	motion.y += GRAVITY
	
	if health > 0:
		match state:
			STATES.IDLE:
				animation_player.play("idle")
			STATES.RUNNING:
				animation_player.play("run")
				
				match running_state:
					DIRECTION.RIGHT:
						motion.x = MAX_SPEED
						if not floor_right.is_colliding() or wall_right.is_colliding():
							running_state = DIRECTION.LEFT

					DIRECTION.LEFT:
						motion.x = -MAX_SPEED
						if not floor_left.is_colliding() or wall_left.is_colliding():
							running_state = DIRECTION.RIGHT

				sprite.scale.x = sign(motion.x)
				
				if ALIVE:
					motion = move_and_slide(motion, Vector2.UP)

func _on_Hurtbox_hit(damage):
	if ALIVE:
		Global.play_boss_hit_sound()

	if not start_fight_timer.is_stopped():
		start_fight_timer.stop()
		state = STATES.RUNNING
	else:
		health -= 1
		
		if ALIVE and health <= 0:
			animation_player.play("dying")
			emit_signal("boss_died")
			ALIVE = false

func _on_StartFightTimer_timeout():
	state = STATES.RUNNING
