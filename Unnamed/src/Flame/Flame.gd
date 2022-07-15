extends Node2D

onready var animator = $SpriteAnimator
onready var label = $Label
onready var eyes = $EyesSprite
onready var particles_base = $ParticlesBase
onready var particles_core = $ParticlesCore

var base_color = Color('#dc721a')
var core_color = Color('#faaa00')
var flash_color = Color('#f4cca1')

var particles = {
	100: {
		"base": load("res://src/Flame/100hp_base.tres"),
		"core": load("res://src/Flame/100hp_core.tres"),
		"base_texture": load("res://assets/flame_base_100-75hp.png"),
		"core_texture": load("res://assets/fame_core_100-75hp.png"),
		"amount": 20,
		"eyes_y": -9,
	},
	75: {
		"base": load("res://src/Flame/75hp_base.tres"),
		"core": load("res://src/Flame/75hp_core.tres"),
		"base_texture": load("res://assets/flame_base_100-75hp.png"),
		"core_texture": load("res://assets/fame_core_100-75hp.png"),
		"amount": 20,
		"eyes_y": -8,
	},
	50: {
		"base": load("res://src/Flame/50hp_base.tres"),
		"core": load("res://src/Flame/50hp_core.tres"),
		"base_texture": load("res://assets/flame_base_50-25hp.png"),
		"core_texture": load("res://assets/flame_core_50-25hp.png"),
		"amount": 20,
		"eyes_y": -8,
	},
	25: {
		"base": load("res://src/Flame/25hp_base.tres"),
		"core": load("res://src/Flame/25hp_core.tres"),
		"base_texture": load("res://assets/flame_base_50-25hp.png"),
		"core_texture": load("res://assets/flame_core_50-25hp.png"),
		"amount": 10,
		"eyes_y": -7,
	}
}

var MAX_HEALTH = 100
var health = 100

func _process(delta):
	label.text = str(health)
	
	
func set_if_different(obj, key, val):
	if obj[key] != val:
		obj[key] = val
	

func set_health(amount):
	health = clamp(0, amount, MAX_HEALTH)

	if (particles_base != null && particles_core != null):
		if health > 75:
			set_if_different(particles_base, "amount", particles[100].amount)
			set_if_different(particles_base, "process_material", particles[100].base)
			set_if_different(particles_base, "texture", particles[100].base_texture)
			set_if_different(particles_core, "amount", particles[100].amount)
			set_if_different(particles_core, "process_material", particles[100].core)
			set_if_different(particles_core, "texture", particles[100].core_texture)
			eyes.position = Vector2(eyes.position.x, particles[100].eyes_y)
		elif health > 50:
			set_if_different(particles_base, "amount", particles[75].amount)
			set_if_different(particles_base, "process_material", particles[75].base)
			set_if_different(particles_base, "texture", particles[75].base_texture)
			set_if_different(particles_core, "amount", particles[75].amount)
			set_if_different(particles_core, "process_material", particles[75].core)
			set_if_different(particles_core, "texture", particles[75].core_texture)
			eyes.position = Vector2(eyes.position.x, particles[75].eyes_y)
		elif health > 25:
			set_if_different(particles_base, "amount", particles[50].amount)
			set_if_different(particles_base, "process_material", particles[50].base)
			set_if_different(particles_base, "texture", particles[50].base_texture)
			set_if_different(particles_core, "amount", particles[50].amount)
			set_if_different(particles_core, "process_material", particles[50].core)
			set_if_different(particles_core, "texture", particles[50].core_texture)
			eyes.position = Vector2(eyes.position.x, particles[50].eyes_y)
		else:
			set_if_different(particles_base, "amount", particles[25].amount)
			set_if_different(particles_base, "process_material", particles[25].base)
			set_if_different(particles_base, "texture", particles[25].base_texture)
			set_if_different(particles_core, "amount", particles[25].amount)
			set_if_different(particles_core, "process_material", particles[25].core)
			set_if_different(particles_core, "texture", particles[25].core_texture)
			eyes.position = Vector2(eyes.position.x, particles[25].eyes_y)
		

func play_idle_animation():
	animator.play("idle")

func move_x(offset_x: float):
	if (particles_base != null && particles_core != null):
		particles_base.position.x = offset_x
		particles_core.position.x = offset_x
		
func set_color(base_color: Color, core_color: Color):
	particles_base.process_material.color = base_color
	particles_core.process_material.color = core_color
	
func reset_color():
	set_color(base_color, core_color)
	
func flash_color():
	set_color(flash_color, flash_color)
