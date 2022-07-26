extends KinematicBody2D

const Fireball = preload("res://src/Fireball/Fireball.tscn")

export(int) var ACCELERATION = 1000
export(float) var AIR_MULT = 0.65
export(int) var FAST_MAX_FALL = 240
export(int) var FAST_MAX_ACCEL = 300
export(int) var FRICTION = 400
export(int) var GRAVITY = 900
export(int) var HALF_GRAVITY_THRESHOLD = 40
export(int) var JUMP_FORCE = 105
export(int) var JUMP_HORIZONTAL_BOOST = 40
export(int) var KNOCKBACK_FORCE = 120
export(int) var MAX_SPEED = 90
export(int) var MAX_FALL = 160
export(int) var WALL_JUMP_CHECK_DIST = 3
export(float) var WALL_JUMP_FORCE_TIME = 0.16
export(float) var WALL_JUMP_HORIZONTAL_SPEED = MAX_SPEED + JUMP_HORIZONTAL_BOOST
export(int) var WALL_SLIDE_START_MAX = 20
export(float) var WALL_SLIDE_TIME = 1.2

enum {
	LEFT = -1,
	NEUTRAL = 0,
	RIGHT = 1
}

# hack: not actually used
# we have this property so that checks for enemy ALIVE
# won't fail when the hurtbox enters the hibox
var ALIVE = true
var facing = NEUTRAL
var game_instances = GameResourceLoader.game_instances
var invincible = false setget set_invincible
var is_holding = false
var just_jumped = false
var knockback_motion = Vector2.ZERO
var max_fall = 0
var motion = Vector2.ZERO
var player_stats = GameResourceLoader.player_stats
var variable_jump_speed = 0
var wall_speed_retained = 0

export(int) var max_jump = 1
export(int) var jump_buffer = 1

var form = -1
var char_form = 0
var boost_jumped = false
var was_in_air = false
var was_on_floor = false

onready var camera = $Camera
onready var collider = $Collider
onready var coyote_jump_timer = $CoyoteJumpTimer
onready var debug_label = $DebugLabel
onready var debug_ray = $DebugRay
onready var hit_animation_player = $HitAnimationPlayer
onready var hurtbox_collider = $Hurtbox/Collider
onready var left_wall_ray_cast = $LeftWallRayCast
onready var jump_sound = $JumpSound
onready var right_wall_ray_cast = $RightWallRayCast
onready var sprite = $Sprite
onready var variable_jump_timer = $VariableJumpTimer
onready var change_form_timer = $ChangeFormTimer
onready var animator = $AnimationPlayer

signal touched_level_transition(level_transition)
signal boss_died

func _exit_tree():
	game_instances.player = null

func _ready():
	reset()
	
	player_stats.connect("player_died", self, "_on_died")
	game_instances.player = self
	
	# Place the player in the correct level connection
	if State.level_connection != null:
		for level_transition in get_tree().get_nodes_in_group("level_transition"):
			# find the correct matching connection
			if level_transition != State.ignored_level_transition and level_transition.connection == State.level_connection:
				global_position = level_transition.get_node('ExitPosition').global_position
				break
	# Otherwise we should be spawning at the last spawn point
	elif State.player_spawn_point != null:
		global_position = State.player_spawn_point
		
	facing = State.player_spawm_facing
	max_jump = State.player_spawn_max_jump
	jump_buffer = max_jump
	sprite.frame = max_jump - 1

func _physics_process(delta):
	just_jumped = false
	boost_jumped = false

	var input_vector = get_input_vector()
	var direction = sign(input_vector.x)
	
	if direction != 0:
		facing = direction
	
	apply_horizontal_force(input_vector, delta)
	handle_collisions(input_vector)
	jump_check(input_vector)
	apply_gravity(delta)
	update_animations(input_vector)
	move()
	handle_additional_input()
	
	# Kill the player dark souls style if we fall below the level
	if global_position.y > 220:
		die()

func _process(delta):
	pass

func animate_hit():
	Controls.rumble_gamepad(Controls.RumbleStrength.Light, Controls.RumbleLength.VeryShort)

func apply_gravity(delta: float):
	max_fall = move_toward(max_fall, MAX_FALL, FAST_MAX_ACCEL * delta)
	var mult = 0.5 if abs(motion.y) < HALF_GRAVITY_THRESHOLD and (Input.is_action_pressed("jump") or boost_jumped) else 1.0
	motion.y = move_toward(motion.y, max_fall, GRAVITY * mult * delta)
	
	if (variable_jump_timer.time_left > 0):
		if Input.is_action_pressed("jump") and not boost_jumped:
			motion.y = min(motion.y, variable_jump_speed)
		else:
			variable_jump_timer.stop()

func apply_horizontal_force(input_vector: Vector2, delta: float):
	var mult = 1.0 if is_on_floor() else AIR_MULT
	
	if abs(motion.x) > MAX_SPEED and sign(motion.x) == input_vector.x:
		motion.x = move_toward(motion.x, input_vector.x * MAX_SPEED, FRICTION * mult * delta)
	else:
		motion.x = move_toward(motion.x, input_vector.x * MAX_SPEED, ACCELERATION * mult * delta)

func die():	
	player_stats.incremenet_deaths()
	Global.play_player_dying_sound()
	Controls.rumble_gamepad(Controls.RumbleStrength.Strong, Controls.RumbleLength.Short)
	
	player_stats.reset_player_stats()
	State.ignored_level_transition = null
	State.level_connection = null
	
	Utils.change_scene(State.current_level)

func freeup_fireball():
	player_stats.fireballs -= 1

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	return input_vector

func handle_additional_input():
	pass
#	if Input.is_action_just_pressed("change_form"):
#		change_form_timer.start()
#		form = (form + 1) % 3
#		char_form = form
#		sprite.frame = char_form
		

func handle_collisions(input_vector: Vector2):
	var dice_value = get_collided_dice_value()
	if dice_value != null:
		max_jump = dice_value
		jump_buffer = dice_value
		sprite.frame = dice_value - 1
	# Relies on speicifically using move_and_slide or mmove_and_slide_with_snap
#	for i in get_slide_count():
#		var collider = get_slide_collision(i).collider
#		var groups = collider.get_groups()
#	if get_collided_jump_platform() == char_form and not was_on_floor and is_on_floor():
#		jump(input_vector, JUMP_FORCE*3.5, JUMP_HORIZONTAL_BOOST*2)
#		boost_jumped = true
#		just_jumped = true

func jump(input_vector: Vector2, force: int, horizontal_force: int):
	variable_jump_timer.start()
	motion.x += input_vector.x * horizontal_force
	motion.y = -force
	variable_jump_speed = motion.y
	
	jump_sound.play()
	
func jump_check(input_vector: Vector2):
	# if max_jump > 0 and near wall: allow jumps regardless of jump_buffer
	# jump buffer should never 
	if max_jump < 1:
		return
	
	if Input.is_action_just_pressed("jump"):
		if not is_on_floor():
			if wall_jump_check(RIGHT):
				wall_jump(LEFT, JUMP_FORCE)
				just_jumped = true
			elif wall_jump_check(LEFT):
				wall_jump(RIGHT, JUMP_FORCE)
				just_jumped = true
			elif jump_buffer >= 1 or coyote_jump_timer.time_left > 0:
				jump(input_vector, JUMP_FORCE, JUMP_HORIZONTAL_BOOST)
				just_jumped = true
				jump_buffer -= 1
		else:
			jump(input_vector, JUMP_FORCE, JUMP_HORIZONTAL_BOOST)
			just_jumped = true
			jump_buffer -= 1
	elif jump_buffer > 0 and Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE / 2.0:
		motion.y = -JUMP_FORCE / 2.0

func move():
	was_in_air = not is_on_floor()
	was_on_floor = is_on_floor()
	
	# by supplying the normal of the surface we can automatically
	# detect when the character is on floor using
	# is_on_floor()
	motion = move_and_slide(motion, Vector2.UP)


	# landing
	if was_in_air and is_on_floor():
		jump_buffer = max_jump
		Controls.rumble_gamepad(Controls.RumbleStrength.Light, Controls.RumbleLength.VeryShort)
	
	# just left ground
	if was_on_floor and not is_on_floor() and not just_jumped:
#		motion.y = 0
		coyote_jump_timer.start()

func reset():
	sprite.frame = max_jump - 1
	char_form = max_jump
	hit_animation_player.stop()
	invincible = false

func set_invincible(value: bool):
	invincible = value

func update_animations(input_vector: Vector2):
	sprite.scale.x = facing
	if input_vector.x != 0:
		if jump_buffer == 6:
			animator.play("Run6")
		elif jump_buffer == 5:
			animator.play("Run5")
		elif jump_buffer == 4:
			animator.play("Run4")
		elif jump_buffer == 3:
			animator.play("Run3")
		elif jump_buffer == 2:
			animator.play("Run2")
		elif jump_buffer == 1:
			animator.play("Run1")
		elif jump_buffer == 0:
			animator.play("Run0")
		else:
			animator.play("Run0")
	else:
		# idle
		if jump_buffer == 6:
			animator.play("Idle6")
		elif jump_buffer == 5:
			animator.play("Idle5")
		elif jump_buffer == 4:
			animator.play("Idle4")
		elif jump_buffer == 3:
			animator.play("Idle3")
		elif jump_buffer == 2:
			animator.play("Idle2")
		elif jump_buffer == 1:
			animator.play("Idle1")
		elif jump_buffer == 0:
			animator.play("Idle0")
		else:
			animator.play("Idle0")
		
	# air
	if not is_on_floor():
		if jump_buffer == 6:
			animator.play("Jump6")
		elif jump_buffer == 5:
			animator.play("Jump5")
		elif jump_buffer == 4:
			animator.play("Jump4")
		elif jump_buffer == 3:
			animator.play("Jump3")
		elif jump_buffer == 2:
			animator.play("Jump2")
		elif jump_buffer == 1:
			animator.play("Jump1")
		elif jump_buffer == 0:
			animator.play("Jump0")
		else:
			animator.play("Jump0")
#		var orientation = sign(motion.y)
#		if orientation == -1:
#			#animate("jump")
#			pass
#		else:
#			pass
#			#animate("fall")	

func update_camera(room):
	var collider = room.get_node("Collider")
	var size = collider.shape.extents * 2
	
	camera.limit_left = collider.global_position.x - size.x / 2
	camera.limit_top = collider.global_position.y - size.y / 2
	camera.limit_right = camera.limit_left + size.x
	camera.limit_bottom = camera.limit_top + size.y

func update_collider(extents):
	if hurtbox_collider.shape == null || collider.shape.extents.x != extents.x || collider.shape.extents.y != extents.y:
		var collider_shape = RectangleShape2D.new()
		collider_shape.extents = extents
		collider.shape = collider_shape
		collider.position = Vector2(0, -extents.y)
		
		var hurtbox_shape = RectangleShape2D.new()
		hurtbox_shape.extents = extents
		hurtbox_collider.shape = hurtbox_shape
		hurtbox_collider.position = Vector2(0, -extents.y)

func wall_jump(dir: int, force: int):
	variable_jump_timer.start()
	motion.x = dir * WALL_JUMP_HORIZONTAL_SPEED
	motion.y = -force
	variable_jump_speed = motion.y
	
	jump_sound.play()
	
func wall_jump_check(dir: int):
	var collider: Object = null
	if dir == LEFT:
		if left_wall_ray_cast.is_colliding():
			collider = left_wall_ray_cast.get_collider()
	elif dir == RIGHT:
		if right_wall_ray_cast.is_colliding():
			collider = right_wall_ray_cast.get_collider()
	
	return collider != null && !collider.is_in_group("level_boundaries")

func _on_died():
	die()
	
func knockback(direction):
	var knockback_motion = (direction * KNOCKBACK_FORCE).rotated(deg2rad(45 if direction.x < 0 else 325))
	knockback_motion.y = min(knockback_motion.y, -200)
	motion = knockback_motion

func _on_RoomDetectorLeft_area_entered(room: Area2D):
	update_camera(room)

func _on_RoomDetectorRight_area_entered(room: Area2D):
	update_camera(room)

func _on_ChangeFormTimer_timeout():
	form = -1

func get_collided_dice_value():
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		if collider.is_in_group('dice'):
			return collider.type
	return null

func _on_Hurtbox_hit(damage, attacker):
	if damage > 0:
		die()
