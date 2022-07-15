extends Control

var player_stats = GameResourceLoader.player_stats
const FireballSprite = preload("res://src/Fireball/FireballSprite.tscn")
onready var fireballs_position = $FireballsPosition

var fireballs = []

func _ready():
	var position = fireballs_position.position
	for i in range(0, 30):
		var fireball = FireballSprite.instance()
		fireball.global_position = position
		fireball.visible = false
		add_child(fireball)
		fireballs.append(fireball)
		position += Vector2(8, 0)

func _process(delta):
	var fireball_amount = 0
	
	if player_stats.health > player_stats.HEALTH_LOW_THRESHOLD:
		fireball_amount = floor((player_stats.health - player_stats.HEALTH_LOW_THRESHOLD) / player_stats.FIREBALL_COST) + 1

	set_fireball_amount(fireball_amount)

func clear():
	for fireball in fireballs:
		fireball.visible = false

func set_fireball_amount(amount):
	clear()
	
	for i in range(0, amount):
		fireballs[i].visible = true
