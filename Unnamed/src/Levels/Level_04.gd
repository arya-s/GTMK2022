extends "res://src/Levels/Level.gd"

onready var spawn_timer = $SpawnTimer
onready var spawner_1 = $OilSpawner1
onready var spawner_2 = $OilSpawner2
onready var spawner_3 = $OilSpawner3
onready var spawner_4 = $OilSpawner4
onready var rat_boss = $RatBoss;
onready var end_screen = $EndScreen;

var spawners = []

func _ready():
	spawners = [spawner_1, spawner_2, spawner_3, spawner_4]
	rat_boss.connect("boss_died", self, "_on_boss_died")
	random_drip()

func _on_boss_died():
	end_screen.visible = true
	
func random_drip():
	var spawner = spawners[randi() % spawners.size()]
	spawner.drip()

func _on_SpawnTimer_timeout():
	random_drip()
