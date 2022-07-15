extends Node2D

var Drop = preload("res://src/WaterDrop/WaterDrop.tscn")

export(Vector2) var drop_velocity = Vector2.DOWN
export(int) var drop_speed = 45
export(float) var drop_interval = 1.5

onready var timer = $Timer
onready var spawn_point = $SpawnPoint

func _ready():
	timer.wait_time = drop_interval

func drip():
	var drop = Utils.instance_scene_on_main(Drop, spawn_point.global_position)
	drop.velocity = drop_velocity * drop_speed


func _on_Timer_timeout():
	drip() # Replace with function body.
